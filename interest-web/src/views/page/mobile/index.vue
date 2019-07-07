<template>
    <div class="mobile-layout">
      <el-container>
        <el-header class="header">
          <el-row :gutter="24" style="margin: 0">
            <el-col :span="24" style="padding: 0">
              <div class="layout-logo">
                  <a @click="backHome()">
                      <img src="@images/logo.jpg" width="50px" height="50px" align="absmiddle" />
                  </a>
              </div>
              <el-dropdown
                trigger="click"
                class="dropdown"
                @command="dropdownClick"
                placement="top-start">

                <span>
                  <el-badge 
                    :value="unreadMsgCount" 
                    class="user-head" 
                    type="primary" 
                    v-if="loginFlag" 
                    max="99" 
                    :hidden="unreadMsgCount <= 0">
                    <img :src="user.headimg"/>
                  </el-badge>
                </span>
                
                <el-dropdown-menu slot="dropdown">
                  <el-dropdown-item command="name" icon="el-icon-user-solid">{{user.name}}</el-dropdown-item>
                  <el-dropdown-item command="email" icon="el-icon-message">邮件</el-dropdown-item>
                  <el-dropdown-item command="messages" icon="el-icon-chat-line-round">消息</el-dropdown-item>
                  <el-dropdown-item command="loginOut" icon="el-icon-switch-button">退出</el-dropdown-item>
                </el-dropdown-menu>
              </el-dropdown>

              <div v-if="!loginFlag" class="login-out">
                  <el-button round @click="toLogin()">
                    <span>登录</span>
                  </el-button>
              </div>

            </el-col>
          </el-row>
        </el-header>

        <el-main class="main">
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
        :close-on-click-modal="false"
        label-position="top"
        width="90%">
        <span>
          <el-form :model="email" :rules="emailRule" ref="email">
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
      loginFlag: false,
      consoleFlag: false,
      loading: true,
      searchValue: "",
      //用户未读消息个数
      unreadMsgCount: 0,
      emailModal: false,
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
  mounted() {
    var code = this.$route.query.code;
    var state = this.$route.query.state;
    this.login(code, state);
  },
  methods: {
    dropdownClick(m) {
      if (m == "email") {
        this.emailModal = true;
      } else if (m == "loginOut") {
        this.$store.dispatch("users/loginOUt", { router: this.$router });
      } else if (m == "messages") {
        this.$router.push({ path: "/mobile/messages" });
      }
    },
    toLogin() {
      this.$router.push("/mobile/login");
    },
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
            this.$message.error("无权限");
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
      if (this.searchValue != null && this.searchValue != "") {
        this.$router.push("/page/home/" + this.searchValue);
      }
    },
    menuSelect(e) {
      if (e == 1) {
      } else if (e == 2) {
        this.emailModal = true;
      } else if (e == 3) {
        this.$store.dispatch("users/loginOUt", { router: this.$router });
      } else if (e == 4) {
        this.$router.push("/base");
      } else if (e == 5) {
        this.$router.push("/login");
      }
    },
    backHome() {
      this.$router.push("/mobile");
    },
    cancel() {
      this.$message.info("点击了取消");
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
                this.$message.info("发送成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
          this.emailModal = false;
        } else {
          this.$message.error("表单验证失败!");
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
            this.$message.error("登陆失败");
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
            this.$message.error("登陆失败");
          }.bind(this)
        );
    },

    toMessages() {
      //console.log('to messages page');
      this.$router.push({ path: "/page/messages" });
    }
  }
};
</script>
<style scoped>
.el-header {
  padding: 0;
}
.mobile-layout {
  background: #f5f7f9;
}
.header {
  background: #fff;
  box-shadow: 0 2px 4px 0 rgba(0,0,0,.05);
}
.main {
  padding: 0;
}
.layout-logo {
  float: left;
  padding: 5px;
}
.dropdown {
  float: right;
}
.dropdown .user-head{
  margin: 7px 30px;
}
.dropdown .user-head img {
  width: 40px;
  height: 40px;
  border-radius: 100%;
}
.layout-footer-center {
  text-align: center;
  background: #fff;
  padding: 20px;
}
.login-out {
  float: right;
  font-size: 15px;
  padding: 10px;
}
.login-out span {
  color: #c92027;
}
</style>