<template>
    <div>
      <div class="user-content">
        <div class="subhead">
          <h1 class="title-text">个人信息</h1>
        </div>
        <el-divider></el-divider>
        <el-row :gutter="24">
          <el-col :span="8" class="headimg">
            <el-avatar class="image" shape="square" :size="100" :src="headImg" @click.native="toggleShow()"></el-avatar>
            <el-button size="medium" type="primary" plain @click="toggleShow()">修改头像</el-button>
          </el-col>
          <el-col :span="16">
            <el-form :model="userInfo" label-position="top" size="medium">
              <el-form-item label="用户名">
                  <el-input v-model="userInfo.name"></el-input>
              </el-form-item>
              <el-form-item label="用户主页">
                  <el-input v-model="userInfo.url"></el-input>
              </el-form-item>
              <el-form-item label="邮箱地址">
                  <el-input v-model="userInfo.email"></el-input>
              </el-form-item>
              <el-form-item label="个人简介">
                  <el-input v-model="userInfo.info" type="textarea" :rows="3"></el-input>
              </el-form-item>
              <el-form-item label="所在位置">
                  <el-input v-model="userInfo.location"></el-input>
              </el-form-item>
              <el-form-item label="擅长技能">
                  <el-input v-model="userInfo.skill"></el-input>
              </el-form-item>
              <el-button size="small" type="primary" class="update-button" @click="updateInfo">更新</el-button>
            </el-form>
          </el-col>
        </el-row>

      </div>
      <my-upload 
        ref="upload"
        field="picture"
        v-model="show"
        :width="200"
        :height="200"
        url="/interest/general/users/user/head-img/upload"
        :headers="headers"
        img-format="png"
        @crop-upload-success="cropUploadSuccess"
        @crop-upload-fail="cropUploadFail">
      </my-upload>
    </div>
</template>
<script>
import myUpload from 'vue-image-crop-upload';
export default {
  components: {
    'my-upload': myUpload
  },
  data() {
    return {
      headImg:'',
      show: false,
      headers: {
        Authorization:'bearer '+ localStorage.getItem("currentUser_token")
      },
      userInfo: {
        headimg:null,
        name:null,
        url:null,
        email:null,
        info:null,
        location:null,
        skill:null
      }
    };
  },
  mounted() {
    this.getUserInfo();
  },
  methods: {
    toggleShow() {
      this.show = !this.show;
    },
    cropUploadSuccess(jsonData, field){
      this.axios({
        method: "patch",
        url: "/general/users/user/headImg",
        params: {
          headImg: jsonData.data
        }
      })
      .then(function(response) {
        this.headImg = jsonData.data;
        this.show = false;
        this.$notify({
          title: '头像修改成功',
          type: 'success'
        });
        this.$refs.upload.off();
      }.bind(this))
      .catch(function(error) {
        alter(error);
      }.bind(this));
    },
    cropUploadFail(status, field){
      this.$notify({
        title: '头像修改失败',
        type: 'error'
      });
      this.$refs.upload.off();
    },
    userInfoSet(e){
      this.userInfo.headimg = e.headimg;
      this.userInfo.name = e.name;
      this.userInfo.url = e.url;
      this.userInfo.email = e.email;
      this.userInfo.info = e.info;
      this.userInfo.location = e.location;
      this.userInfo.skill = e.skill;
    },
    getUserInfo(){
      this.axios({
          method: "get",
          url: "/general/users/user/info"
      })
      .then(
          function(response) {
            this.userInfoSet(response.data.data);
            this.headImg = response.data.data.headimg;
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    },
    updateInfo(){
      this.axios({
        method: "put",
        url: "/general/users/user/info",
        data: this.userInfo
      })
      .then(
          function(response) {
            this.$notify({
              title: '修改成功',
              type: 'success'
            });
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    }
  }
};
</script>
<style scoped>
.el-form--label-top .el-form-item__label {
  padding: 0;
  font-size: 12px;
}
.el-form-item {
  margin-bottom: 0;
}
.user-content {
  width: 550px;
  margin:0 auto;
  background: #fff;
  padding: 20px;
}
.user-content .subhead {
  text-align: center;
}
.user-content .title-text {
  color: #24292e;
}
.user-content .info {
  padding:16px 16px;
  float: left;
  width: 400px;
  color: #24292e;
}
.user-content .info label {
  color: #24292e;
}
.user-content .headimg {
  text-align: center;
}
.user-content .headimg .image {
  cursor: pointer;
}
.user-content .update-button {
  margin-top: 20px;
  width: 100%;
}
</style>