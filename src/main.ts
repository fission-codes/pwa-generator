import * as webnative from 'webnative';

// @ts-expect-error
import { Elm } from './Main.elm';

const app = Elm.Main.init({
  node: document.querySelector('main'),
  flags: {
    window: {
      width: window.innerWidth,
      height: window.innerHeight
    }
  }
});

let fs;

const fissionInit = {
  permissions: {
    app: {
      name: 'pwa-generator',
      creator: 'bgins'
    }
  }
};


webnative.initialize(fissionInit).then(async state => {
  switch (state.scenario) {
    case webnative.Scenario.AuthSucceeded:
    case webnative.Scenario.Continuation:
      app.ports.onAuthChange.send({
        username: state.username
      })

      fs = state.fs;

      const appPath = fs.appPath();
      const appDirectoryExists = await fs.exists(appPath);

      if (!appDirectoryExists) {
        await fs.mkdir(appPath);
        await fs.publish();
      }

      const manifestDirectories = await fs.ls(appPath);
      const manifests = await Promise.all(Object.keys(manifestDirectories).map(async shortName => {
        const path = fs.appPath([`${shortName}`, `${shortName}.json`]);
        return JSON.parse(await fs.read(path));
      }));
      app.ports.onManifestsLoaded.send(manifests);

      break;

    case webnative.Scenario.NotAuthorised:
    case webnative.Scenario.AuthCancelled:
      app.ports.onAuthChange.send(null);
      break;
  }

  app.ports.login.subscribe(() => {
    webnative.redirectToLobby(state.permissions);
  });

  /* PERSISTENCE */

  // app.ports.load.subscribe(async shortName => {
  //   const path = fs.appPath([
  //     `${shortName}`,
  //     `${shortName}.json`
  //   ]);
  //   const manifest = JSON.parse(await fs.read(path));
  //   app.ports.onManifestLoaded.send(manifest);
  // });

  app.ports.save.subscribe(async manifest => {
    const manifestDirectory = fs.appPath(`${manifest.short_name}`);
    const manifestDirectoryExists = await fs.exists(manifestDirectory);

    if (!manifestDirectoryExists) {
      await fs.mkdir(manifestDirectory);
      await fs.publish();
    }

    const manifestPath = fs.appPath([
      `${manifest.short_name}`,
      `${manifest.short_name}.json`
    ]);

    await fs.write(manifestPath, JSON.stringify(manifest));
    await fs.publish();
    app.ports.onManifestSaved.send(manifest);
  });

  app.ports.delete.subscribe(async manifest => {
    const path = fs.appPath([
      `${manifest.short_name}`,
      `${manifest.short_name}.json`
    ]);

    await fs.rm(path);
    await fs.publish();
    app.ports.onManifestDeleted.send(manifest);
  });
});



// CLIPBOARD

app.ports.copyToClipboard.subscribe(async id => {
  const el = await document.getElementById(id);

  // create range over node
  const range = document.createRange();
  range.selectNodeContents(el);

  // get selection, clear and replace from range
  const selection = window.getSelection();
  selection.removeAllRanges();
  selection.addRange(range);

  // copy selection to clipboard, then clear it
  document.execCommand("copy");
  selection.removeAllRanges();
});