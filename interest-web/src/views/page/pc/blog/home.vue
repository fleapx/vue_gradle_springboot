<template>
    <div id="article_home" class="article-home">
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
            class="pagination"
            background
            layout="total, prev, pager, next"
            :total="total"
            :page-size="pageInfo.pageSize"
            @current-change="e=>{pageSearch(e)}">
          </el-pagination>
        </div>
      </div>
  </div>
</template>
<script>
export default {
  name: 'article_home',
  data() {
    return {
      searchContent:null,
      articleList: [],
      total: 0,
      pageInfo: {
        page: 0,
        pageSize: 20
      }
    };
  },
  mounted() {
    this.getArticle({
      pageInfo: this.pageInfo
    });
  },
  watch: {
    $route: ["search"]
  },
  methods: {
    search(){
      this.searchContent = this.$route.query.searchValue;
      this.getArticle({
        pageInfo: this.pageInfo
      });
    },
    getArticle(e) {
      this.axios({
        method: "get",
        url: "/public/articles",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          searchContent: this.searchContent
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
<style scoped>
.pagination {
  padding: 20px;
}
.article-home {
  width: 80%;
  margin: 0 auto;
}

.user-article {
  background: #fff;
  box-shadow: 0 2px 4px 0 rgba(0,0,0,0.05);
  font-size: 14px;
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
</style>