#!/bin/bash
mkdir $1
cd $1
mkdir src
cd src
mkdir components
cd ..
touch README.adoc
cat >> README.adoc <<EOL
= $1
ifdef::env-github[]
:tip-caption: :bulb:
:note-caption: :information_source:
:important-caption: :heavy_exclamation_mark:
:caution-caption: :fire:
:warning-caption: :warning:
endif::[]

NOTE: $3
EOL

touch LICENSE.adoc
cat >> LICENSE.adoc <<EOL
MIT License

Copyright (c) 2020 $2

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOL

touch .gitignore
cat >> .gitignore <<EOL
node_modules
dist
coverage
package-lock.json
yarn.lock
__snapshots__
EOL

touch package.json
cat >> package.json <<EOL
{
  "name": "$1",
  "version": "0.1.0",
  "description": "$3",
  "license": "MIT",
  "main": "index.js",
  "scripts": {
    "test": "(npm run lint || true ) && jest --coverage",
    "lint": "eslint ./src --ext .tsx",
    "start": "npx webpack --mode=development --watch",
    "build": "npx webpack -p",
    "deploy": "npx webpack -p && gh-pages -d dist"
  },
  "jest": {
    "roots": [
      "<rootDir>/src"
    ],
    "transform": {
      "^.+\\\\.tsx?$": "ts-jest"
    },
    "testRegex": "(/__tests__/.*|(\\\\.|/)(test|spec))\\\\.tsx?$",
    "moduleFileExtensions": [
      "ts",
      "tsx",
      "js",
      "jsx",
      "json",
      "node"
    ]
  },
  "devDependencies": {
    "@types/jest": "latest",
    "@types/node-sass": "latest",
    "@types/react": "latest",
    "@types/react-dom": "latest",
    "@types/react-test-renderer": "latest",
    "@types/reactstrap": "latest",
    "@typescript-eslint/eslint-plugin": "latest",
    "@typescript-eslint/parser": "latest",
    "css-loader": "latest",
    "eslint": "latest",
    "eslint-plugin-react": "latest",
    "gh-pages": "latest",
    "html-loader": "latest",
    "jest": "latest",
    "node-sass": "latest",
    "react-test-renderer": "latest",
    "sass-loader": "latest",
    "source-map-loader": "latest",
    "style-loader": "latest",
    "ts-jest": "latest",
    "ts-loader": "latest",
    "typescript": "latest",
    "webpack": "latest",
    "webpack-cli": "latest"
  },
  "dependencies": {
    "bootstrap": "latest",
    "jquery": "latest",
    "popper.js": "latest",
    "react": "latest",
    "react-dom": "latest",
    "reactstrap": "latest"
  }
}
EOL

touch tsconfig.json
cat >> tsconfig.json <<EOL
{
  "compilerOptions": {
    // Output directory for building
    "outDir": "./dist/",
    // Include module source maps for debugging
    "sourceMap": true,
    // Force to specify type (also any)
    "noImplicitAny": true,
    // Force to define enclosing execution context
    "noImplicitThis": true,
    // Use specified module system
    "module": "commonjs",
    // Import CommonJS modules in compliance with es6 modules spec
    "esModuleInterop": true,
    // Allow importing like `import React from 'react'`
    "allowSyntheticDefaultImports": true,
    // Include typings from built-in lib declarations
    "lib": ["dom", "dom.iterable", "es5", "es6"],
    // Transpile final code to ES5 standard
    "target": "es5",
    // Set React as the JSX factory
    "jsx": "react",
  },
  "exclude": [
    "**/*.spec.ts",
    "node_modules",
    "public"
  ],
}
EOL

touch webpack.config.js
cat >> webpack.config.js <<EOL
// eslint-disable-next-line no-undef
module.exports = {
  mode: "production",

  // Enable sourcemaps for debugging webpack's output.
  devtool: "source-map",

  entry: './src/index.tsx',

  resolve: {
    // Add '.ts', '.tsx' and '.js' as resolvable extensions.
    extensions: [".ts", ".tsx", ".js"]
  },

  module: {
    rules: [
      {
        test: /\.ts(x?)$/,
        exclude: /node_modules/,
        use: 'ts-loader',
      },
      // All output '.js' files will have any sourcemaps re-processed by 'source-map-loader'.
      {
        enforce: "pre",
        test: /\.js$/,
        loader: "source-map-loader"
      },
      {
        test: /\.s?css$/,
        exclude: /node_modules/,
        loaders: [ 'style-loader', 'css-loader', 'sass-loader' ]
      },
      {
        test: /\.html$/,
        loader: 'html-loader'
      },
    ]
  },

  // When importing a module whose path matches one of the following, just
  // assume a corresponding global variable exists and use that instead.
  // This is important because it allows us to avoid bundling all of our
  // dependencies, which allows browsers to cache those libraries between builds.
  externals: {
    react: "React",
    "react-dom": "ReactDOM"
  }
};
EOL

touch .eslintrc.js
cat >> .eslintrc.js <<EOL
// eslint-disable-next-line no-undef
module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  plugins: [
    '@typescript-eslint',
  ],
  extends: [
    'eslint:recommended',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:@typescript-eslint/recommended',
    'plugin:react/recommended',
  ],
  settings: {
    react: {
      version: "detect"
    }
  }
};
EOL

touch index.html
cat >> index.html <<EOL
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons" />
    <title>$1</title>
  </head>
  <body>
    <div id="root"></div>
	
    <!-- Dependencies -->
    <script src="./node_modules/react/umd/react.development.js"></script>
    <script src="./node_modules/react-dom/umd/react-dom.development.js"></script>
	
    <!-- Main -->
    <script src="./dist/main.js"></script>
  </body>
</html>
EOL

cd src
touch index.tsx
cat >> index.tsx <<EOL
import './index.scss';

import React from 'react';
import ReactDOM from 'react-dom';

import { App } from './components/app';

ReactDOM.render(
  <App compiler='TypeScript' framework='React' />,
  document.getElementById('root')
);
EOL

touch index.scss
cat >> index.scss <<EOL
@import "../node_modules/bootstrap/dist/css/bootstrap.min.css";
EOL

cd components
touch app.tsx
cat >> app.tsx <<EOL
import React, { Component } from 'react';

import { Alert } from "reactstrap";

export interface AppProps {
  compiler: string;
  framework: string;
}

export class App extends Component {
  props: AppProps;

  render = (): JSX.Element => {
    return (
      <div className="container mt-5">
        <Alert color="success">
          <h4 className="alert-heading">Well done!</h4>
          <p>
            Aww yeah, you successfully installed this boilerplate. This is an app build with {this.props.compiler} and {this.props.framework}! 
            With Bootstrap and Reactstrap on top of it!
          </p>
          <hr />
          <p className="mb-0">
            Whenever you need to, be sure to use margin utilities to keep things nice and tidy.
          </p>
        </Alert>
      </div>
    )
  }
}
EOL

touch app.spec.tsx
cat >> app.spec.tsx << EOL
import React from 'react';
import { App } from "./app";
import { render, unmountComponentAtNode } from "react-dom";
import { act } from "react-dom/test-utils";

let container: HTMLElement;
beforeEach(() => {
  // setup a DOM element as a render target
  container = document.createElement("div");
  document.body.appendChild(container);
});

afterEach(() => {
  // cleanup on exiting
  unmountComponentAtNode(container);
  container.remove();
  container = null;
});

test('Test App component', () => {
  // Render a title HP content
  act(() => {
    render( < App compiler = 'TypeScript' framework = 'React' /> , container);
  });
  expect(container.textContent).toBe("Well done!Aww yeah, you successfully installed this boilerplate. This is an app build with TypeScript and React! With Bootstrap and Reactstrap on top of it!Whenever you need to, be sure to use margin utilities to keep things nice and tidy.");
});
EOL

yarn install
