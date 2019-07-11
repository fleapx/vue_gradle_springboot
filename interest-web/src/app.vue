<template>
    <div>
        <router-view></router-view>
    </div>
</template>
<style lang="scss">
body {
    font-family: "Helvetica Neue",Helvetica,"PingFang SC","Hiragino Sans GB","Microsoft YaHei","微软雅黑",Arial,sans-serif;
    font-size: 12px;
    line-height: 1.5;
    color: #515a6e;
    -moz-osx-font-smoothing: grayscale;
}

html {
    font-family: sans-serif;
    line-height: 1.15;
    -webkit-text-size-adjust: 100%;
}
article, aside, blockquote, body, button, dd, details, div, dl, dt, fieldset, figcaption, figure, footer, form, h1, h2, h3, h4, h5, h6, header, hgroup, hr, input, legend, li, menu, nav, ol, p, section, td, textarea, th, ul {
    margin: 0;
    padding: 0;
}

a {
  color: #333;
  font-size: 14px;
  text-decoration: none;
  cursor: pointer;

  &:hover {
    color: #57a3f3;
  }
}
</style>
