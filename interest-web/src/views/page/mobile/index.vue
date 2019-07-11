<template>
    <div class="mobile-layout">
      <el-container>
        <el-header class="header">
          <el-row :gutter="24" style="margin: 0">
            <el-col :span="8" style="padding: 0">
              <div class="menu" v-clickoutside="outsideClose">
                <el-button icon="el-icon-menu" circle @click="dropdownListShow = !dropdownListShow"></el-button>
              </div>
            </el-col>
            <el-col :span="8" style="padding: 0">
              <div class="layout-logo">
                <a @click="backHome()">
                  INTEREST
                </a>
            </div>
            </el-col>
            <el-col :span="8" style="padding: 0">
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
          <transition name="fade">
            <ul v-if="dropdownListShow" class="dropdown-list">
              <li 
                v-for="item in dropdownListData" 
                :key="item.id"
                :class="{'li-acitve' : acitve == item.id}"
                @click="dropdownListClick(item)">
                {{item.name}}
              </li>
            </ul>
            
          </transition>
          
        </el-header>

        <el-main class="main">
          <router-view></router-view>
        </el-main>

        <el-footer class="layout-footer-center" height="100">
          <div>
              <a href="https://github.com/smallsnail-wh" target="_blank">
                <img src="@images/GitHub.svg" width="40px" height="40px"/>
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
      acitve: null,
      dropdownListData: [{
        id: 'home',
        path: '/mobile',
        name: '首页'
      },{
        id: 'article',
        path: '/mobile/article',
        name: '文章'
      }],
      dropdownListShow: false,
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
        id: null,
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
    this.login(code, state);
  },
  directives:{
    clickoutside:{
        bind:function(el,binding,vnode){
            function documentHandler(e){
                if(el.contains(e.target)){
                    return false;
                }
                if(binding.expression){
                    binding.value(e)
                }
            }
            el._vueClickOutside_ = documentHandler;
            document.addEventListener('click',documentHandler);
        },
        unbind:function(el,binding){
            document.removeEventListener('click',el._vueClickOutside_);
            delete el._vueClickOutside_;
        }
    },
  },
  methods: {
    dropdownListClick(val){
      this.acitve = val.id;
      this.$router.push(val.path);
    },
    outsideClose(){
      this.dropdownListShow = false;
    },
    dropdownClick(m) {
      if (m == "email") {
        this.emailModal = true;
      } else if (m == "loginOut") {
        this.$store.dispatch("users/loginOUt", { router: this.$router });
      } else if (m == "messages") {
        this.$router.push({ path: "/mobile/messages" });
      } else if(m == "name"){
        this.$router.push('/mobile/user/' + this.user.id);
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
      this.user.id = e.id;
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
        const loading = this.$loading({
          lock: true,
          text: '正在登陆...',
          spinner: 'el-icon-loading',
          background: 'rgba(0, 0, 0, 0.7)'
        });
        if (state == "github") {
          this.githubLogin(code,loading);
        } else if (state == "qq") {
          this.qqLogin(code,loading);
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

            this.userGet();
            this.$router.push({ path: "/mobile" });
            // this.$router.push({ path: "/" });
            // location.reload();
          }.bind(this)
        )
        .catch(
          function(error) {
            this.$message.error("登陆失败");
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
            this.userGet();
            this.$router.push({ path: "/mobile" });
            // this.$router.push({ path: "/qq" });
            // this.$router.push({ path: "/" });
            // location.reload();
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
.menu {
 font-size: 30px;
 padding-left: 15px;
}
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
  text-align: center;
}
.layout-logo a {
  color: #663399;
  font-size: 20px;
  line-height: 60px;
  font-weight: bold;
}
.dropdown {
  float: right;
}
.dropdown .user-head{
  margin: 12px 30px;
}
.dropdown .user-head img {
  width: 35px;
  height: 35px;
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
.dropdown-list {
  width: 100%;
  height: 100%;
  z-index: 2003;
  position: absolute;
  top: 60px;
  color: rgba(102, 51, 153, 0.5);
  background-color: rgba(0, 0, 0, 0.7);
}
.li-acitve {
  color: rgb(102, 51, 153);
  border-left: 4px solid rgb(102, 51, 153);
}
.dropdown-list li {
  background-color: #fff;
  font-weight: bold;
  font-size: 18px;
  text-align: center;
  padding: 15px;
  border-top: 1px solid #ebedf0;
}
.overlay {
  z-index: 2002;
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.7);
}
.fade-enter-active, .fade-leave-active{
  transition: height .3s ease;
}
.fade-enter, .fade-leave-to {
  height: 0;
}
.fade-enter-to, .fade-leave {
  height: auto;
} 
</style>