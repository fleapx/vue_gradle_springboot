<template>
  <div id="i_user_info" class="i-user-info-container">
    <el-card class="user-info-card" shadow="never">
      <div slot="header" class="user-head">
        <el-row :gutter="24">
          <el-col :span="24">
            <div class="headimg">
              <img :src="userInfo.headimg">
            </div>
            <div class="user-name">
              <h4>{{userInfo.name}}</h4>
            </div>
          </el-col>
        </el-row>
      </div>
      <div class="user-info">
        {{userInfo.info}}
        <span v-if="userInfo.info == null || userInfo.info == ''" class="span-default">未填写......</span>
      </div>
      <div class="user-location cotent-form">
        <i class="el-icon-location-outline icon"></i>
        <span class="span-line-feed">{{userInfo.location}}</span>
        <span v-if="userInfo.location == null || userInfo.location == ''" class="span-default">未填写......</span>
      </div>
      <div class="user-url cotent-form">
        <i class="el-icon-attract icon"></i>
        <a :href="userInfo.url" target="_blank">
          <span class="span-line-feed">{{userInfo.url}}</span>
        </a>
        <span v-if="userInfo.url == null || userInfo.url == ''" class="span-default">未填写......</span>
      </div>
      <div class="user-email cotent-form">
        <i class="el-icon-message icon"></i>
        <span class="span-line-feed">{{userInfo.email}}</span>
        <span v-if="userInfo.email == null || userInfo.email == ''" class="span-default">未填写......</span>
      </div>
      <div class="user-skill cotent-form">
        <i class="el-icon-bicycle icon"></i>
        <span class="span-line-feed">{{userInfo.skill}}</span>
        <span v-if="userInfo.skill == null || userInfo.skill == ''" class="span-default">未填写......</span>
      </div>
    </el-card>
  </div>
</template>
<script>
export default {
  name: 'i_user_info',
  props: {
    userInfo: Object
  },
  data() {
    return {
    };
  },
  mounted() {
  },
  methods: {
  }
};
</script>
<style  scoped></style>
<style scoped>
.el-card {
  box-shadow: 0 2px 4px 0 rgba(0,0,0,0.05);
  border: 0;
}
.i-user-info-container {
  width:280px;
  color: #333;
  background: #fff;
}
.span-line-feed {
  word-break: break-all;
  white-space: normal;
}
.span-default {
  color: #c5c8ce;
}
.user-info-card {
  font-size: 14px;
}
.user-info-card .icon {
  margin-right: 5px;
  margin-left: -19px;
}
.user-info-card .cotent-form {
  margin-bottom: 5px;
  padding-left: 19px;
}
.user-info-card .user-head{
  /*height: 40px;*/
}
.user-info-card .user-head .headimg{
  height: 40px;
  float: left;
  margin-right: 10px;
}
.user-info-card .user-head .headimg img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin: 0 auto;
}
.user-info-card .user-head .user-name{
  float: left;
  padding-top: 9.5px;
}
.user-info-card .user-info{
  font-size: 16px;
  margin-bottom: 10px;
}

.user-info-card .user-location{
  
}
.user-info-card .user-url{
  
}
.user-info-card .user-url a{
  color: #2d8cf0;
}
.user-info-card .user-url a:hover{
  color: #2d8cf0;
  text-decoration: underline;
}
.user-info-card .user-email{
  
}
.user-info-card .user-skill{
  
}
</style>