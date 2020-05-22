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

NOTE: TBD
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
    "start": "npx webpack --watch",
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
  }
}
EOL

touch tsconfig.json
cat >> tsconfig.json <<EOL
{
  "compilerOptions": {
    "outDir": "./dist/",
    "sourceMap": true,
    "allowSyntheticDefaultImports": true,
    "noImplicitAny": true,
    "noImplicitThis": true,
    "lib": ["dom", "esnext"],
    "module": "esnext",
    "esModuleInterop": true,
    "target": "es5",
    "jsx": "react"
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

  resolve: {
    // Add '.ts' and '.tsx' as resolvable extensions.
    extensions: [".ts", ".tsx"]
  },

  module: {
    rules: [
      {
        test: /\.ts(x?)$/,
        exclude: /node_modules/,
        use: [
          {
            loader: "ts-loader"
          }
        ]
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
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
    <title>React boilerplate</title>
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
import React from 'react';
import ReactDOM from 'react-dom';

import { Hello } from './components/hello';

ReactDOM.render(
  <Hello compiler='TypeScript' framework='React' />,
  document.getElementById('root')
);
EOL

cd components
touch hello.tsx
cat >> hello.tsx <<EOL
import React from 'react';

export interface HelloProps {
  compiler: string;
  framework: string;
}

export const Hello = (props: HelloProps): JSX.Element => (
  <h1>
    Hello from {props.compiler} and {props.framework}!
  </h1>
);
EOL

touch hello.spec.tsx
cat >> hello.spec.tsx << EOL
import React from 'react';
import { Hello } from "./hello";
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

test('Test HelloProps', () => {
  // Render a h1 title
  act(() => {
    render( < Hello compiler = 'TypeScript' framework = 'React' /> , container);
  });
  expect(container.textContent).toBe("Hello from TypeScript and React!");
});
EOL

yarn add -D webpack webpack-cli gh-pages

yarn add react react-dom

yarn add -D @types/react @types/react-dom

yarn add -D typescript ts-loader css-loader html-loader sass-loader style-loader source-map-loader 

yarn add -D eslint @typescript-eslint/parser @typescript-eslint/eslint-plugin eslint-plugin-react

yarn add -D jest ts-jest @types/jest react-test-renderer
