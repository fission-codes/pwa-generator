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

      break;

    case webnative.Scenario.NotAuthorised:
    case webnative.Scenario.AuthCancelled:
      app.ports.onAuthChange.send(null);
      break;
  }

  app.ports.login.subscribe(() => {
    webnative.redirectToLobby(state.permissions);
  });
});