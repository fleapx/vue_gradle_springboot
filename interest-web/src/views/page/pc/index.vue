<template>
    <div class="index">
      <el-container>
        <el-header class="header" height="62">
          <el-row :gutter="24">
            <el-col :span="10">
              <div class="layout-logo">
                  <a @click="backHome()">
                      <img src="../../../images/logo.jpg" style="width: 50px;height: 50px;" align="absmiddle" />
                  </a>
              </div>
              <el-menu 
                text-color="#66339980"
                active-text-color="#663399"
                :default-active="activeIndex" 
                class="left-menu" 
                mode="horizontal" 
                @select="menuSelect">
                <el-menu-item index="home">首页</el-menu-item>
                <el-menu-item index="article-home">文章</el-menu-item>
              </el-menu>
              <el-input class="search-input" v-model="searchValue" placeholder="Enter something..." @keyup.enter.native="search" size="small">
                <i class="el-icon-search el-input__icon" slot="suffix" @click="search"></i>
              </el-input>
            </el-col>
            <el-col :span="14">
              <el-menu 
                active-text-color="#409EFF"
                v-if="loginFlag"
                class="right-menu" 
                mode="horizontal" 
                @select="menuSelect">
                <el-menu-item index="name">{{user.name}}</el-menu-item>
                <el-menu-item index="email"><i class="el-icon-message"></i>邮件</el-menu-item>
                <el-submenu index="article">
                  <template slot="title"><i class="el-icon-tickets"></i>文章</template>
                  <el-menu-item index="write-article" class="sub-menu-item"><i class="el-icon-edit"></i>写文章</el-menu-item>
                  <el-menu-item index="my-article" class="sub-menu-item"><i class="el-icon-document"></i>我的文章</el-menu-item>
                </el-submenu>
                <el-menu-item index="login-out"><i class="el-icon-switch-button"></i>退出</el-menu-item>
                <el-menu-item index="console" v-if="consoleFlag"><i class="el-icon-s-tools"></i>控制台</el-menu-item>
              </el-menu>
              <el-badge :value="unreadMsgCount" class="user-head" type="primary" v-if="loginFlag">
                <img :src="user.headimg" @click="menuSelect('message')"/>
              </el-badge>
            </el-col>
            <div class="login" v-if="!loginFlag" @click="menuSelect('login')">
              <i class="el-icon-user-solid"></i>登陆
            </div>
            </el-col>
          </el-row>
        </el-header>

        <el-main>
          <router-view></router-view>
        </el-main>

        <el-footer class="layout-footer-center" height="100">
          <div>
              <a href="https://github.com/smallsnail-wh" target="_blank">
                  <Icon style="color: rebeccapurple;" size="40" type="logo-github"></Icon>
              </a>
          </div>
          <p>Copyright &copy; 2019 smallsail-wh</p>
        </el-footer>
      </el-container>

      <el-dialog
        title="联系管理员"
        :visible.sync="emailModal"
        :before-close="handleClose"
        width="600px"
        :close-on-click-modal="false">
        <span>
          <el-form :model="email" :rules="emailRule" ref="email" label-width="80px">
            <el-form-item label="标题" prop="title">
              <el-input v-model="email.title"></el-input>
            </el-form-item>
            <el-form-item label="email" prop="email">
              <el-input v-model="email.email"></el-input>
            </el-form-item>
            <el-form-item label="姓名" prop="name">
              <el-input v-model="email.name"></el-input>
            </el-form-item>
            <el-form-item label="内容" prop="content">
              <el-input v-model="email.content" type="textarea" :autosize="{ minRows: 2, maxRows: 4}"></el-input>
            </el-form-item>
          </el-form>
        </span>
        <span slot="footer" class="dialog-footer">
          <el-button @click="emailModal = false">取 消</el-button>
          <el-button type="primary" @click="emailOk('email')">确 定</el-button>
        </span>
      </el-dialog>
    </div>
</template>
<script>
export default {
  data() {
    return {
      activeIndex: null,

      loginFlag: false,
      consoleFlag: false,
      loading: true,
      searchValue: "",
      emailModal: false,
      //用户未读消息个数
      unreadMsgCount: 0,
      email: {
        title: "",
        email: "",
        name: "",
        content: ""
      },
      user: {
        loginName: "",
        email: "",
        headimg: "",
        name: ""
      },
      emailRule: {
        title: [
          { required: true, message: '请输入密码', trigger: 'blur' }
        ],
        email: [
          { required: true, message: "输入邮箱", trigger: "blur" },
          { type: "email", message: "输入正确的邮箱格式", trigger: "blur" }
        ],
        name: [
          { required: true, message: '请输入姓名', trigger: 'blur' }
        ],
        content: [
          { required: true, message: "请输入内容", trigger: "blur" }
        ]
      }
    };
  },
  created() {
    if(this.$route.name == "home" || this.$route.name == "page-home-title"|| this.$route.name == "page-home"){
      this.activeIndex = 'home';
    }else if(this.$route.name == "article-home"){
      this.activeIndex = 'article-home';
    }else {
      this.activeIndex = null;
    }
    var code = this.$route.query.code;
    var state = this.$route.query.state;
    if (this.$store.getters._isMobile) {
      if (code != null && code != "" && state != null && state != "") {
        this.$router.replace("/mobile" + "?code=" + code + "&state=" + state);
        return;
      } else {
        this.$router.replace("/mobile");
        return;
      }
    }
    this.login(code, state);
  },
  methods: {
    userGet() {
      let _this = this;
      this.axios({
        method: "get",
        url: "/public/user"
      })
        .then(
          function(response) {
            if (response.data.data != null && response.data.data != "") {
              this.loginFlag = true;
              this.userSet(response.data.data);
              if (response.data.data.usertype == 1) {
                this.consoleFlag = true;
              }

              return this.axios({
                method: "get",
                url: "/msgrecords/unreadnum"
              });
            } else {
              return Promise.resolve(0);
            }
          }.bind(this)
        )
        .then(function(response) {
          if (response === 0) {
            _this.unreadMsgCount = response;
          } else {
            _this.unreadMsgCount = response.data.data;
          }
        })
        .catch(
          function(error) {
            this.$message({
              message: '无权限',
              type: 'error'
            });
          }.bind(this)
        );
    },
    userSet(e) {
      this.user.loginName = e.loginName;
      this.user.email = e.email;
      this.user.headimg = e.headimg;
      this.user.name = e.name;
    },
    search() {
      if(this.$route.name == "home" || this.$route.name == "page-home-title"|| this.$route.name == "page-home"){
        this.$router.push("/page/home/" + this.searchValue);
      }else if(this.$route.name == "article-home"){
        this.$router.push("/article" + "?searchValue=" + this.searchValue);
      }
    },
    menuSelect(key) {
      if(key == 'home'){
        this.$router.push("/");
      }else if(key == 'article-home'){
        this.$router.push("/article");
      }else if(key == 'message'){
        this.$router.push({ path: "/page/messages" });
      }else if(key == 'name'){
        this.$router.push("/page/user");
      }else if(key == 'email'){
        this.emailModal = true;
      }else if(key == 'write-article'){
        this.$router.push("/article/create");
      }else if(key == 'my-article'){
        this.$router.push("/article/user");
      }else if(key == 'login-out'){
        this.$store.dispatch("users/loginOUt", { router: this.$router });
      }else if(key == 'console'){
        this.$router.push("/base");
      }else if(key == 'login'){
        this.$router.push("/login");
      }
    },
    backHome() {
      this.$router.push("/page/home");
    },
    emailOk(email) {
      this.$refs[email].validate(valid => {
        if (valid) {
          this.axios({
            method: "post",
            url: "/email",
            data: this.email
          })
            .then(
              function(response) {
                this.$message({
                  message: '发送成功',
                  type: 'success'
                });
                this.emailModal = false;
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
        } else {
          return false;
        }
      });
    },
    /*登录*/
    login(code, state) {
      if (code != null && code != "" && state != null && state != "") {
        const loading = this.$loading({
          lock: true,
          text: '正在登陆...',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });
        if (state == "github") {
          this.githubLogin(code,loading);
        } else if (state == "qq") {
          this.qqLogin(code),loading;
        } else {
          this.$router.push({ path: "/" });
          location.reload();
        }
      } else {
        this.userGet();
      }
    },
    /*github登录*/
    githubLogin(code,loading) {
      this.axios({
        method: "post",
        url: "/authentication/github",
        params: {
          code: code
        },
        auth: {
          username: "client",
          password: "secret"
        }
      })
        .then(
          function(response) {
            loading.close();
            localStorage.setItem(
              "currentUser_token",
              response.data.access_token
            );
            localStorage.setItem(
              "currentUser_refresh_token",
              response.data.refresh_token
            );
            this.axios.defaults.headers.common["Authorization"] =
              "bearer " + localStorage.getItem("currentUser_token");
            this.$router.push({ path: "/" });
            location.reload();
          }.bind(this)
        )
        .catch(
          function(error) {
            loading.close();
            this.$message({
              message: '登陆失败',
              type: 'error'
            });
          }.bind(this)
        );
    },
    /*qq登录*/
    qqLogin(code,loading) {
      this.axios({
        method: "post",
        url: "/authentication/qq",
        params: {
          code: code
        },
        auth: {
          username: "client",
          password: "secret"
        }
      })
        .then(
          function(response) {
            loading.close();
            localStorage.setItem(
              "currentUser_token",
              response.data.access_token
            );
            localStorage.setItem(
              "currentUser_refresh_token",
              response.data.refresh_token
            );
            this.axios.defaults.headers.common["Authorization"] =
              "bearer " + localStorage.getItem("currentUser_token");
            this.$router.push({ path: "/qq" });
            this.$router.push({ path: "/" });
            location.reload();
          }.bind(this)
        )
        .catch(
          function(error) {
            loading.close();
            this.$message({
              message: '登陆失败',
              type: 'error'
            });
          }.bind(this)
        );
    },
  }
};
</script>
<style scoped>
.index {
  min-width: 1000px;
  background: #f5f7f9;
}
.login {
  float: right;
  height: 60px;
  line-height: 60px;
  margin: 0;
  font-size: 14px;
  padding: 0 20px;
  cursor: pointer;
}
.login:hover {
  color: #409EFF;
}
.login i {
  margin-right: 5px;
  width: 24px;
  text-align: center;
  font-size: 18px;
  vertical-align: middle;
  color: #409EFF;
}
.el-menu.el-menu--horizontal {
  border-bottom: solid 0 #e6e6e6;
}
.header {
  border-bottom: solid 1px #e6e6e6;
  padding-bottom: 2px;
  background: #fff;
}

.layout-logo {
  float: left;
  padding: 5px;
}
.left-menu {
  font-weight: bold;
  float: left;
  height: 60px;
  margin-left: 10px;
}
.search-input {
  float: left;
  width: 160px;
  margin: 14px 0 14px 20px;
}
.right-menu {
  float: right;
  height: 60px;
}
.user-head {
  margin-top: 15px;
  float: right;
}
.user-head img {
  width: 30px;
  height: 30px;
  border-radius: 100%;
  cursor: pointer;
}
.sub-menu-item {
  width: 117px;
}
.layout-footer-center {
  text-align: center;
  background: #fff;
  padding: 20px;
}
</style>
<style >
.el-menu--popup {
  min-width: 0;
}
</style>