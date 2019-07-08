<template>
  <div class="login-container">
    <div class="content-container">
      <div class="login-form-wrapper">
        <el-form
          :model="formLogin"
          :rules="ruleLogin"
          ref="formLogin"
          label-width="120px"
          class="login-form">
          <el-form-item label-width="0" class="login-header">
            <img src="../images/logo.jpg" align="absmiddle" />
            <h2 class="title">INTEREST</h2>
          </el-form-item>
          <el-divider></el-divider>
          <div class="name-password-error" v-if="this.$store.state.ifSign">用户名或密码错误</div>
          <el-form-item label-width="0" prop="userName">
            <el-input
              v-model="formLogin.userName"
              @keyup.enter.native="login('formLogin')"
              placeholder="登录名"
              autofocus>
                <i class="el-icon-user-solid" slot="prepend"></i>
              </el-input>
          </el-form-item>

          <el-form-item label-width="0" prop="password">
            <el-input
              v-model="formLogin.password"
              @keyup.enter.native="login('formLogin')"
              type="password"
              placeholder="密码">
                <i class="el-icon-lock" slot="prepend"></i>
              </el-input>
          </el-form-item>

          <el-form-item label-width="0">
            <el-button class="width-100-percent" type="primary" @click="login('formLogin')">登陆</el-button>
          </el-form-item>
          <div class="other-login">
            <a :href="githubLoginUrl">
                <img src="@images/GitHub.svg" class="margin-right-20" />
            </a>
            <a :href="qqLoginUrl">
                <img src="@images/social-qq.svg" />  
            </a>
          </div>
        </el-form>
      </div>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      githubLoginUrl: 'https://github.com/login/oauth/authorize?client_id=bbb5cc2034eb62484c1c&state=github',
      qqLoginUrl: 'https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=101512648&redirect_uri=http://www.lovemtt.com/qq&state=qq',
      formLogin: {
        userName: null,
        password: null
      },
      ruleLogin: {
        userName: [
          { required: true, message: "请填写用户名", trigger: "blur" }
        ],
        password: [
          { required: true, message: "请填写密码", trigger: "blur" }
          ]
      }
    };
  },
  mounted() {
    if (!this.$store.getters._isMobile) {
      this.$router.replace("/ login");
    }
  },
  methods: {
    login(formLogin) {
      this.$refs[formLogin].validate(valid => {
        if (valid) {
          this.$store.dispatch("users/userLogin", {
            user_name: this.formLogin.userName,
            user_password: this.formLogin.password,
            router: this.$router
          });
        }else {
          return false;
        }
      });
    },
  }
};
</script>
<style scoped lang="scss">
.margin-right-20 {
  margin-right: 50px;
}
.other-login {
  text-align: center;

  .el-form-item__content {
    line-height: 0;
  }

  img {
    width: 35px;
    height: 40px;
  }
}
.name-password-error {
  padding-bottom: 4px;
  text-align: left;
  line-height: 1;
  color: #ed3f14;
}
.login-header {
  text-align: center;

  img {
    width: 40px;
    height: 40px;
    float: left;
  }
}
.width-100-percent {
  width: 100%;
}
.login-container {
  width: 100%;
  height: 100vh;
}

.content-container {
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  background-image: url(../images/login.jpg);
  transition: all 0.3s ease-in-out;

  .login-form-wrapper {
    text-align: center;
    padding: 10px;
    flex: 1 1 auto;

    .login-form {
      padding: 20px 40px 20px;
      display: inline-block;
      border-radius: 10px;
      text-align: left;
      background-color: #fff;
      box-shadow: 0 15px 35px rgba(50, 50, 93, 0.1),
        0 5px 15px rgba(0, 0, 0, 0.07);

      .title {
        color: rgb(102, 51, 153);
      }
    }
  }
}
</style>