import * as webnative from 'webnative';

// @ts-expect-error
import { Elm } from './Main.elm';

const app = Elm.Main.init({
  node: document.querySelector('main'),
});