<template>
    <div class="layout">
      <el-container>
        <el-aside class="left-aside" width="17%">
          <div class="logo">
            <a @click="backHome()">
                <img src="@images/logo.jpg" align="absmiddle" />
            </a>
            <span>控制台</span>
          </div>
          <el-menu 
            background-color="#515a6e"
            text-color="#fff"
            active-text-color="#ffd04b">
            <el-submenu v-for="pmenu in menuList" :index="pmenu.id" :key="pmenu.id">
              <template slot="title">
                <Icon :type="pmenu.icon"></Icon>
                {{pmenu.name}}
              </template>
              <el-menu-item v-for="cmenu in pmenu.children" :index="cmenu.url" :key="cmenu.id" @click="menuClick(cmenu)">
                <Icon :type="cmenu.icon"></Icon>
                {{cmenu.name}}
              </el-menu-item>
            </el-submenu>
          </el-menu>
        </el-aside>

        <el-container>
          <el-header class="header">
            <div class="login-out" @click="loginOut">
              <i class="el-icon-switch-button"></i>
              退出
            </div>
            <div class="user-info">
              <el-avatar :size="size" :src="headImg"></el-avatar>
              <span>{{userName}}</span>
            </div>
          </el-header>

          <el-main>
            <router-view></router-view>
          </el-main>

          <el-footer class="layout-footer-center" height="80px">
            <div>
              <a href="https://github.com/smallsnail-wh" target="_blank">
                <img src="@images/GitHub.svg" width="40px" height="40px"/>
              </a>
            </div>
            <p>Copyright &copy; 2019 smallsail-wh</p>
          </el-footer>
        </el-container>
      </el-container>
    </div>
</template>
<script>
export default {
  data() {
    return {
      /*用户名*/
      userName: null,
      headImg: null,
      /*一级菜单*/
      menuList: [],
      /*二级菜单*/
      menuSub: [],
      /*面包屑data*/
      breadcrumbData: []
    };
  },
  created() {
    /*this.$router.push();*/
    /*this.userName = window.localStorage.getItem("currentUser_name");*/
    this.axios({
      method: "get",
      url: "/public/user"
    })
      .then(
        function(response) {
          this.userName = response.data.data.name;
          this.headImg = response.data.data.headimg;
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
    this.axios({
      method: "get",
      url: "/manage/menu"
    })
      .then(
        function(response) {
          this.menuList = response.data.data;
          for (var i in this.menuList) {
            for (var j in this.menuList[i].children) {
              this.menuSub.push(this.menuList[i].children[j]);
            }
          }
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
  },
  methods: {
    menuClick(val){
      console.log(val);
      this.$router.push(val.url);
    },
    loginOut(){
      this.$store.dispatch("users/loginOUt", { router: this.$router });
    },
    /*菜单选择事件*/
    select(index, indexPath) {
      this.$router.push(index);
    },
    backHome() {
      this.$router.push("/page/home");
    }
  }
};
</script>
<style lang="scss" scoped>
.el-menu {
  border-right: 0;
}
.layout {
  min-width: 1000px;
  background: #f5f7f9;

  .left-aside {
    background: #464c5b;

    .logo {
      text-align: center;
      padding: 20px;

      img {
        width: 50px;
        height: 50px;
      }

      span {
        color: #f5af00;
        font-size: 16px;
        margin-left: 10px;
      }
    }
  }
  .header {
    background-color: #fff;
    box-shadow: 0 2px 4px 0 rgba(0,0,0,.05);

    .user-info {
      float: right;
      height: 60px;
      display: flex;
      display: -webkit-flex;
      align-items: center;
      padding: 0 20px;

      span {
        color: #515a6e;
        font-size: 14px;
        margin-right: 10px;
      }
    }
    .login-out {
      float: right;
      height: 60px;
      display: flex;
      display: -webkit-flex;
      align-items: center;
      color: #515a6e;
      font-size: 14px;
      cursor: pointer;
      padding: 0 20px;

      &:hover {
        color: #5cb6ff;
      }

      i {
        margin-right: 5px;
      }
    }
  }
  .layout-footer-center {
    text-align: center;
    background: #fff;
    padding: 10px;
  }
}
</style>