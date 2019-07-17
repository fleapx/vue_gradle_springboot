<template>
  <div class="home-layout">
    <el-row class="row-content" :gutter="24" style="margin: 0 auto;">
      <el-col :span="24" style="padding-left: 0; padding-right: 0;">
        <div class="interest-content">
          <el-carousel trigger="click" height="450px">
            <el-carousel-item v-for="(item,index) in bannerList" :key="index">
              <router-link :to="('/page/detail/'+item.id)">
                  <img  class="banner-images" v-bind:src="(item.image)">
                </router-link>
            </el-carousel-item>
          </el-carousel>

          <div v-if="flage" class="search-nothing">
            <span>未找到符合条件的结果</span>
          </div>

          <div class="interest">
            <div class="info" v-for="(A,index) in homeArticle">
              <div class="box-flex even-layout" v-if="index%2==0">
                <div class="image">
                    <router-link :to="('/page/detail/'+A.id)">
                      <img v-bind:src="(A.image)">
                    </router-link>
                </div>
                <div class="text-content">
                    <router-link :to="('/page/detail/'+A.id)">
                      <span class="title">{{A.title}}</span>
                    </router-link>
                    <span class="content">{{A.info}}</span>
                </div>
              </div>
              <div class="box-flex odd-layout" v-else>
                  <div class="text-content">
                      <router-link :to="('/page/detail/'+A.id)">
                        <span class="title">{{A.title}}</span>
                      </router-link>
                      <span class="content">{{A.info}}</span>
                  </div>
                  <div class="image">
                      <router-link :to="('/page/detail/'+A.id)">
                        <img v-bind:src="(A.image)">
                      </router-link>
                  </div>
              </div>
            </div>
          </div>
        </div>

        <div class="right-aside">
          <el-card class="notice" shadow="never">
            <div slot="header" class="notice-head">
              <i class="el-icon-basketball"></i>
              INTEREST 项目介绍
            </div>
            <p>一个开源项目</p>
            <p>源码地址：<a href="https://github.com/Big-Chinese-Cabbage/interest" target="_blank">https://github.com/Big-Chinese-Cabbage/interest</a></p>
          </el-card>
          <affix>
            <el-card class="notice" shadow="never">
              <div slot="header" class="notice-head">
                <i class="el-icon-message-solid"></i>
                公告栏
              </div>
              <el-carousel height="60px" direction="vertical">
                <el-carousel-item v-for="item in textNoticeList" :key="item.id">
                  <p>{{item.content}}</p>
                </el-carousel-item>
              </el-carousel>
            </el-card>

            <el-card class="notice" shadow="never">
              <el-row :span="24" v-for="item in pictureNoticeList" :key="item.id" class="picture-notice">
                <el-col :span="8">
                  <a :href="item.url" target="_blank">
                    <el-image :src="item.image" :fit="fit"></el-image>
                  </a>
                </el-col>
                <el-col :span="16" class="article-title">
                  <a :href="item.url" target="_blank">
                    <p>{{item.content}}</p>
                  </a>
                </el-col>
              </el-row>
            </el-card>
          </affix>
        </div>
      </el-col>
    </el-row>
    


  </div>
    
</template>
<script>
import affix from '@components/affix.vue';
export default {
  components: {
    'affix': affix
  },
  data() {
    return {
      pictureNoticeList: [],
      textNoticeList: [],
      userInfo: {
        headimg:null,
        name:null,
        url:null,
        email:null,
        info:null,
        location:null,
        skill:null
      },
      flage: false,
      value2: 0,
      homeArticle: [],
      bannerList: []
    };
  },
  mounted() {
    this.getHomeArticle();
    this.getBanner();
    this.getNotice();
  },
  watch: {
    $route: ["getHomeArticle"]
  },
  methods: {
    getNotice(){
      this.axios({
          method: "get",
          url: "/public/notices",
          params: {
            form: 0
          }
      })
      .then(
          function(response) {
            this.textNoticeList = response.data.data;
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
        this.axios({
          method: "get",
          url: "/public/notices",
          params: {
            form: 1
          }
      })
      .then(
          function(response) {
            this.pictureNoticeList = response.data.data;
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    },
    getUserInfo(val){
      this.axios({
          method: "get",
          url: "/public/users/user/info",
          params: {
            userId: val
          }
      })
      .then(
          function(response) {
            this.userInfo = response.data.data;
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    },
    getBanner() {
      this.axios({
        method: "get",
        url: "/public/banners"
      })
        .then(
          function(response) {
            this.bannerList = response.data.data;
          }.bind(this)
        )
        .catch(
          function(error) {
            this.$message({
              message: '无权限',
              type: 'error'
            });
          }.bind(this)
        );
    },
    getHomeArticle() {
      if (this.$route.params.title == null) {
        this.axios({
          method: "get",
          url: "/public/interests"
        })
          .then(
            function(response) {
              this.homeArticle = response.data.data;
            }.bind(this)
          )
          .catch(
            function(error) {
              this.$message({
                message: '无权限',
                type: 'error'
              });
            }.bind(this)
          );
      } else {
        this.axios({
          method: "get",
          url: "/public/interests",
          params: {
            title: this.$route.params.title
          }
        })
          .then(
            function(response) {
              this.homeArticle = response.data.data;
              if (this.homeArticle.length == 0) {
                this.flage = true;
              } else {
                this.flage = false;
              }
            }.bind(this)
          )
          .catch(
            function(error) {
              this.$message({
                message: '无权限',
                type: 'error'
              });
            }.bind(this)
          );
      }
    }
  }
};
</script>
<style scoped>
.home-layout {
  margin: 0 auto;
}
.banner-images {
  width: 100%;
  height: auto;
}
.interest {
  margin-top: 3%;
}
.interest .info {
  margin-bottom: 20px;
  box-shadow: 0 2px 8px 0 rgba(7, 17, 27, 0.06);
}
.interest .info:last-child{
  margin-bottom: 0;
}
.interest .info .image{
  flex: 1;
}
.interest .info .image img {
  display: block;
  width: 100%;
  transition: 0.7s all;
  opacity: 0.8;
}
.interest .info .image img:hover {
  opacity: 1;
  box-shadow: 1px 1px 20px #333;
  transform: scale(1.1, 1.1);
  cursor: pointer;
}
.interest .info .text-content {
  display: flex;
  display: -webkit-flex;
  flex: 1;
  padding: 3%;
  flex-direction: column;
}
.interest .info .text-content .title {
  font-size: 140%;
  transition: 0.8s all;
}
.interest .info .text-content .title:hover {
  text-decoration: line-through;
  cursor: pointer;
}
.interest .info .text-content .content {
  font-size: 100%;
}
.interest .info .text-content a{
  text-decoration: none;
  color: #333;
}
.interest .info .text-content a:hover{
  color: #57a3f3;
}
.interest .info .text-content a:link, a:visited{
  text-decoration: none;
  border: 0;
}
.search-nothing {
  background: #fff;
  padding: 24px 50px;
  color: #495060;
  font-size: 16px;
  text-align: center;
}
.box-flex {
  display: flex;
  display: -webkit-flex;
}
.even-layout, .odd-layout {
  width: 100%;
  background-color: #fff;
}
.interest-content {
  width: 840px;
  float: left;
}
.right-aside {
  float: right;
  width: 300px;
}
.right-aside .notice {
  box-shadow: 0 2px 4px 0 rgba(0,0,0,0.05);
  margin-bottom: 10px;
}
.right-aside .notice .notice-head {
  font-size: 18px;
  color: #663399;
}
.right-aside .notice p {
  font-size: 14px;
}
.row-content {
  width: 1160px;
}
.el-image {
  display: block;
}
.article-title {
  padding: 11px;
}
.picture-notice {
  border-bottom: 1px solid #ccc;
  margin-bottom: 5px;
  padding-bottom: 5px;
}
.picture-notice:last-child {
  border-bottom: 0;
  margin-bottom: 0;
  padding-bottom: 0;
}
</style>