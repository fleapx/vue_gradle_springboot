<template>
  <div id="userPage" class="user-page-container">
    <el-row :gutter="24">
      <el-col :span="24">
        <i-user-info :user-info="userInfo" class="user-info"></i-user-info>

        <div class="user-article">
          <el-card v-for="(item,index) in articleList" :key="index" class="card-body" shadow="hover">
            <div class="title">
              <router-link :to="('/article/detail/'+item.id)">
                <span>{{item.title}}</span>
              </router-link>
            </div>
            <div class="info">
              <p>{{item.info}}</p>
            </div>
            <dl class="list-user-other">
              <dt>
                <a :href="$store.state.userUrlPre+item.userid" target="_blank">
                  <el-avatar :src="item.userHeadImg" size="small"></el-avatar>
                </a>
              </dt>
              <dd>
                <a :href="$store.state.userUrlPre+item.userid" target="_blank">
                    {{item.userName}}
                </a>
              </dd>
              <div class="interval"></div>
              <dd>{{dateGet(item.createTime)}}</dd>
              <div class="right-info">
                <dd>
                  <router-link :to="('/article/detail/'+item.id)">
                    <span class="text">阅读数</span>
                    <span class="num">{{item.clickRate}}</span>
                  </router-link>
                </dd>
                <div class="interval"></div>
                <dd>
                  <router-link :to="('/article/detail/'+item.id)">
                    <span class="text">评论数</span>
                    <span class="num">{{item.commentCount}}</span>
                  </router-link>
                </dd>
              </div>
            </dl>
          </el-card>
          
          <div class="paging" v-if="total > 0">
            <el-pagination
              class="paging"
              background
              layout="total, prev, pager, next"
              :total="total"
              :page-size="pageInfo.pageSize"
              @current-change="e=>{pageSearch(e)}">
            </el-pagination>
          </div>
          <div v-if="total <= 0" class="default-article-content">
            <img src="@images/05d044b1335c6d79ef253b1de1797b08.jpg" />
            <span>该用户很懒一篇文章都没写...</span>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>
<script>
import iUserInfo from '@components/i-user-info.vue';
export default {
  name:'userPage',
  components: {iUserInfo},
  data() {
    return {
      userId: null,
      userInfo: {
        headimg:null,
        name:null,
        url:null,
        email:null,
        info:null,
        location:null,
        skill:null
      },
      articleList: [],
      total: 0,
      pageInfo: {
        page: 0,
        pageSize: 20
      }
    };
  },
  mounted() {
    this.userId = this.$route.params.id;
    this.getUserInfo();
    this.getArticle({
      pageInfo: this.pageInfo
    });
  },
  methods: {
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
          url: "/public/users/user/info",
          params: {
            userId: this.userId
          }
      })
      .then(
          function(response) {
            this.userInfoSet(response.data.data);
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
        url: "/users/user/info",
        data: this.userInfo
      })
      .then(
          function(response) {
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    },
    getArticle(e) {
      this.axios({
        method: "get",
        url: "/public/users/user/"+this.userId+"/articles",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize
        }
      })
        .then(
          function(response) {
            this.articleList = response.data.data.data;
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getArticle({
        pageInfo: this.pageInfo,
      });
    }
  }
};
</script>
<style  scoped></style>
<style scoped>
.user-page-container {
  /*background: #fff;*/
  width: 90%;
  margin: 0 auto;
}
.user-info {
  float: left;
  margin-right: 20px;
}
.user-article {
  font-size: 14px;
  width: calc(100% - 300px);
  background: #fff;
  float: left;
  box-shadow: 0 2px 4px 0 rgba(0,0,0,0.05);
}
.page-left {
  float: left;
  margin-right: 10px;
  margin-left: 5px;
}
.page-right {
  min-width: 700px;
  width: 70%;
  float: left;
}
.headimg img {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  margin: 0 auto;
}

.ivu-form .ivu-form-item-label {
  color: #24292e;
}
.content-background {
  background: #fff;
}
.user-content {
  width: 550px;
  margin:0 auto;
  height: 700px;
}
.user-content .subhead {
    border-bottom: 1px solid #e1e4e8;
    padding-bottom: 8px;
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
.user-content .headimg img {
  width: 100px;
    height: 100px;
    border-radius: 50%;
    margin: 0 auto;
}
.user-content .update-button {
  width: 100%;
}
.card-body {
    padding: 10px;
  }
  .content{
    word-wrap: break-word;
    word-break: break-all;
    overflow: hidden;
  }
  .chat{
    display: inline;
    margin-right: 50px;
    color:#f90;
  }
  .chat span{
    margin-left: 2px;
  }
  .title {
    margin-bottom: 8px;
  }
  .title span{
    color: #2d64b3;
    font-size: 19px;
  }
  .info {
    margin-bottom: 5px;
  }
  .info p{
    width:100%;
    overflow:hidden;
    text-overflow:ellipsis; 
    white-space:nowrap;
  }
  .list-user-other {
    height: 24px;
    line-height: 24px;
  }
  .list-user-other dt{
    float: left;
    margin: 0 6px 0 0;
  }
  .list-user-other dd{
    float: left;
    font-size: 14px;
    color: #8a8a8a;
    line-height: 24px;
  }
  .list-user-other .right-info {
    line-height: 24px;
    float: right;
  }
  .list-user-other .right-info .text {
    margin-right: 4px;
    color: #8a8a8a;
  }
  .list-user-other .right-info .num {
    color: #3399ea;
  }
  .interval {
    float: left;
    width: 1px;
    height: 12px;
    border-radius: 50%;
    background-color: #e0e0e0;
    margin-top: 6px;
    margin-left: 8px;
    margin-right: 8px;
  }
  .paging {
    margin: 20px;
  }
  .default-article-content {
    text-align: center;
    height: 100px;
  }
  .default-article-content img{
    width: 100px;
    height: 100px;
  }
  .default-article-content span{
    color: #24292e;
    margin-left: 20px;
    position: relative;
    top: -45px;
    font-size: 23px;
  }
</style>
