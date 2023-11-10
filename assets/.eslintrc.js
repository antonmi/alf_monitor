module.exports = {
  root: true,
  env: {
    node: true,
  },
  extends: ["eslint:recommended", "plugin:react/recommended"],
  parserOptions: {
    parser: "babel-eslint",
    "sourceType": "module",
    "ecmaVersion": 2020
  }
};
