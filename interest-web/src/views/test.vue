<template>
    <div class="index">
        <el-container>
          <el-header class="header" height="62">
            <el-row :gutter="24">
              <el-col :span="10">
                <div class="layout-logo">
                    <a @click="backHome()">
                        <img src="../images/logo.jpg" style="width: 50px;height: 50px;" align="absmiddle" />
                    </a>
                </div>
                <el-menu 
                  text-color="#66339980"
                  active-text-color="#663399"
                  :default-active="activeIndex" 
                  class="left-menu" 
                  mode="horizontal" 
                  @select="">
                  <el-menu-item index="1">首页</el-menu-item>
                  <el-menu-item index="2">文章</el-menu-item>
                </el-menu>
                <el-input class="search-input" v-model="searchValue" placeholder="Enter something..." @click="search" size="small">
                  <i class="el-icon-search el-input__icon" slot="suffix" @click="search"></i>
                </el-input>
              </el-col>
              <el-col :span="14">
                <el-menu 
                  active-text-color="#409EFF"
                  v-if="loginFlag"
                  class="right-menu" 
                  mode="horizontal" 
                  @select="">
                  <el-menu-item index="1">{{user.name}}</el-menu-item>
                  <el-menu-item index="2"><i class="el-icon-message"></i>邮件</el-menu-item>
                  <el-submenu index="3">
                    <template slot="title"><i class="el-icon-tickets"></i>文章</template>
                    <el-menu-item index="31"><i class="el-icon-edit"></i>写文章</el-menu-item>
                    <el-menu-item index="32"><i class="el-icon-document"></i>我的文章</el-menu-item>
                  </el-submenu>
                  <el-menu-item index="4"><i class="el-icon-switch-button"></i>退出</el-menu-item>
                  <el-menu-item index="5"><i class="el-icon-s-tools"></i>控制台</el-menu-item>
                </el-menu>
                <el-badge :value="unreadMsgCount" class="user-head" type="primary">
                  <img v-if="loginFlag" :src="user.headimg" />
                </el-badge>
              </el-col>
              <div class="login" v-if="!loginFlag">
                <i class="el-icon-user-solid"></i>登陆
              </div>
              </el-col>
            </el-row>
          </el-header>

          <el-main>Main</el-main>

          <el-footer>Footer</el-footer>
        </el-container>
    </div>
</template>
<script>
export default {
  data() {
    return {
      activeIndex: "1",

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
          {
            type: "string",
            required: true,
            message: "请输入密码",
            trigger: "blur"
          }
        ],
        email: [
          { required: true, message: "输入邮箱", trigger: "blur" },
          { type: "email", message: "输入正确的邮箱格式", trigger: "blur" }
        ],
        passwordAgain: [
          {
            type: "string",
            required: true,
            message: "请输入再次输入密码",
            trigger: "blur"
          }
        ],
        name: [
          {
            type: "string",
            required: true,
            message: "请输入姓名",
            trigger: "blur"
          }
        ],
        content: [{ required: true, message: "请输入内容", trigger: "blur" }]
      }
    };
  },
  created() {
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
            this.$Message.error("无权限");
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
    menuSelect(e) {
      if (e == 1) {
        this.$router.push("/page/user");
      } else if (e == 2) {
        this.emailModal = true;
      } else if (e == 31) {
        this.$router.push("/article/create");
      } else if (e == 32) {
        this.$router.push("/article/user");
      } else if (e == 4) {
        this.$store.dispatch("users/loginOUt", { router: this.$router });
      } else if (e == 5) {
        this.$router.push("/base");
      } else if (e == 6) {
        this.$router.push("/login");
      } else if (e == "interest") {
        this.$router.push("/");
      } else if (e == "article") {
        this.$router.push("/article");
      }
    },
    backHome() {
      this.$router.push("/page/home");
    },
    cancel() {
      this.$Message.info("点击了取消");
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
                this.$Message.info("发送成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
          this.emailModal = false;
        } else {
          this.$Message.error("表单验证失败!");
          setTimeout(() => {
            this.loading = false;
            this.$nextTick(() => {
              this.loading = true;
            });
          }, 1000);
        }
      });
    },
    /*登录*/
    login(code, state) {
      if (code != null && code != "" && state != null && state != "") {
        this.$Spin.show({
          render: h => {
            return h("div", [
              h("Icon", {
                style: {
                  animation: "ani-demo-spin 1s linear infinite"
                },
                props: {
                  type: "load-c",
                  size: 18
                }
              }),
              h("div", "正在登录，请等待...")
            ]);
          }
        });
        setTimeout(() => {
          this.$Spin.hide();
        }, 10000);
        if (state == "github") {
          this.githubLogin(code);
        } else if (state == "qq") {
          this.qqLogin(code);
        } else {
          this.$router.push({ path: "/" });
          location.reload();
        }
      } else {
        this.userGet();
      }
    },
    /*github登录*/
    githubLogin(code) {
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
            this.$Message.error("登陆失败");
          }.bind(this)
        );
    },
    /*qq登录*/
    qqLogin(code) {
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
            this.$Message.error("登陆失败");
          }.bind(this)
        );
    },

    toMessages() {
      console.log("to messages page");
      this.$router.push({ path: "/page/messages" });
    }
  }
};
</script>
<style scoped>
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
.index {
  min-width: 1000px;
}
.el-menu.el-menu--horizontal {
  border-bottom: solid 0 #e6e6e6;
}
.header {
  border-bottom: solid 1px #e6e6e6;
  padding-bottom: 2px;
}
.layout {
  border: 1px solid #d7dde4;
  background: #f5f7f9;
  position: relative;
  border-radius: 4px;
  overflow: hidden;
  min-width: 1000px;
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
}

.layout-search {
  height: 30px;
  border-radius: 3px;
  float: left;
  position: relative;
  left: 30px;
}

.layout-title {
  margin-left: 30px;
  height: inherit;
  float: left;
}

.layout-title .home-text{
  color: rebeccapurple;
  font-weight: bold;
}

.layout-title .home-text:hover{
  color: #2d8cf0;
}

.menu-layout {
  height:65px;
  width:100%;
}
.layout-nav {
  height: inherit;
  float: right;
}

.layout-footer-center {
  text-align: center;
  background: #fff;
}

.demo-spin-icon-load {
  animation: ani-demo-spin 1s linear infinite;
}

.avatar-badge-wrapper {
  position: relative;
  float: right;
  cursor: pointer;
}

.avatar-badge-wrapper .msg-num {
  position: absolute;
  top: 9px;
  right: -12px;
  color: #fff;
  background-color: #2db7f5;
  border-radius: 50%;
  padding: 2px 5px;
  line-height: 1;
}

@keyframes ani-demo-spin {
  from {
    transform: rotate(0deg);
  }
  50% {
    transform: rotate(180deg);
  }
  to {
    transform: rotate(360deg);
  }
}
</style>