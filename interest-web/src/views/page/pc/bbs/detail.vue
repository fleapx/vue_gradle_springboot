<template>
  <div class="detail-layout">
    <div class="interest-title">
      {{insterest.title}}
    </div>

    <div class="ql-container ql-snow interest-content">
      <div class="ql-editor">
        <div v-html="insterest.content"></div>
      </div>
    </div>

    <div class="post-card">
      <div class="post-card-head">
          <p>看帖</p>
      </div>
      <el-card v-for="(item,index) in postcardList" :key="index" shadow="hover">
        <div slot="header" class="clearfix">
          <div class="chat">
            <i class="el-icon-chat-line-round"></i>
            <span>{{item.replyCount}}</span>
          </div>
          <router-link :to="('/page/card/'+item.id)">
              <span class="title-text">{{item.title}}</span>
          </router-link>
          <a :href="$store.state.userUrlPre+item.userid" target="_blank" class="user-info">
              <img :src="item.headimg">
              {{item.username}}
            </a>
        </div>
        <div>
          <p class="content">{{item.content}}</p>
          <span>
            <i class="el-icon-time"></i>
            {{item.replytime}}
          </span>
        </div>
      </el-card>
      <el-pagination
        hide-on-single-page
        class="pagination"
        background
        layout="total, prev, pager, next"
        :total="total"
        :page-size="pageInfo.pageSize"
        @current-change="e=>{pageSearch(e)}">
      </el-pagination>
    </div>
    <el-divider></el-divider>
    <div class="send-card">
      <div class="padding-5">
        <span><i class="el-icon-edit-outline"></i>发帖</span>
      </div>
      <div class="padding-5">
        <el-input v-model="title" placeholder="标题"></el-input>
      </div>
      <div class="padding-5">
        <el-input v-model="textarea" type="textarea" rows="6" placeholder="内容"></el-input>
      </div>
    </div>
    <div class="send-button">
      <el-button type="primary" @click="sendCard()">发表</el-button>
    </div>
  </div>
</template>
<script>
export default {
  data() {
    return {
      postcardList: [],
      interestid: null,
      insterest: {
        id: "",
        title: "",
        info: "",
        content: "",
        image: ""
      },
      total: 0,
      pageInfo: {
        page: 0,
        pageSize: 20
      },
      textarea: "",
      title: ""
    };
  },
  mounted() {
    this.interestid = this.$route.params.id;
    this.getArticle(this.$route.params.id);
    this.getPostCard({
      pageInfo: this.pageInfo,
      interestid: this.interestid
    });
  },
  methods: {
    getArticle(e) {
      this.axios({
        method: "get",
        url: "/public/interests/interest",
        params: {
          id: e
        }
      })
        .then(
          function(response) {
            this.insterestSet(response.data.data);
          }.bind(this)
        )
        .catch(
          function(error) {
            alter(error);
          }.bind(this)
        );
    },

    listDateSet(e) {
      for (var i = e.length - 1; i >= 0; i--) {
        e[i].replytime = this.dateGet(e[i].replytime);
      }
    },
    getPostCard(e) {
      this.axios({
        method: "get",
        url: "/public/postcards",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          interestid: e.interestid
        }
      })
        .then(
          function(response) {
            this.postcardList = response.data.data.data;
            this.listDateSet(this.postcardList);
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getPostCard({
        pageInfo: this.pageInfo,
        interestid: this.interestid
      });
    },
    insterestSet(e) {
      this.insterest.id = e.id;
      this.insterest.title = e.title;
      this.insterest.info = e.info;
      this.insterest.content = e.content;
      this.insterest.image = e.image;
    },
    sendCard() {
      if (
        this.title != null &&
        this.textarea != null &&
        this.title != "" &&
        this.textarea != ""
      ) {
        if (
          this.axios.defaults.headers.common["Authorization"] != null &&
          this.axios.defaults.headers.common["Authorization"] != ""
        ) {
          this.axios({
            method: "post",
            url: "/postcards/postcard",
            data: {
              interestid: this.interestid,
              title: this.title,
              content: this.textarea
            }
          })
            .then(
              function(response) {
                this.$message({
                  message: '发帖成功',
                  type: 'success'
                });
                this.title = "";
                this.textarea = "";
                this.pageInfo.page = 0;
                this.getPostCard({
                  pageInfo: this.pageInfo,
                  interestid: this.interestid
                });
              }.bind(this)
            )
            .catch(
              function(error) {
                alter(error);
              }.bind(this)
            );
        } else {
          this.$message({
            message: '登录后，才能发帖！',
            type: 'error'
          });
        }
      } else {
        this.$message({
            message: '请填写标题和内容',
            type: 'error'
          });
      }
    }
  }
};
</script>
<style lang="scss" scoped>
.padding-5 {
  padding: 5px;
}
.clearfix:before,
.clearfix:after {
  display: table;
  content: "";
}
.clearfix:after {
  clear: both
}

.detail-layout {
  background: #fff;
  padding: 20px;
  width: 80%;
  margin: 0 auto;

  .interest-title {
    font-size: 220%;
    line-height: 50px;
    text-align: center;
  }

  .interest-content {
    border: 1px solid #ccc;
    border-radius: 40px;
    padding: 20px 0;
  }

  .post-card {
    width: 100%;
    margin: 50px 0 20px 0;

    .post-card-head {
      background: #eceef2;
      border-bottom: 1px solid #e8eaec;
      padding: 14px 16px;
      line-height: 1;

      p {
        display: inline-block;
        width: 100%;
        height: 20px;
        line-height: 20px;
        font-size: 14px;
        color: #17233d;
        font-weight: 700;
        overflow: hidden;
        text-overflow: ellipsis;
        white-space: nowrap;
      }
    }

    .chat{
      float: left;
      display: inline;
      margin-right: 50px;
      color:#f90;

      i {
        font-size: 25px;
      }

      span{
        margin-left: 2px;
        font-size: 14px;
      }
    }

    .title-text {
      float: left;
      color: #2d64b3;
      font-size: 18px;
      overflow: hidden;
      text-overflow:ellipsis;
      white-space: nowrap;
      width: 70%;

      &:hover {
        color: #57a3f3;;
      }
    }

    .user-info {
      float: right;
      font-size: 14px;
      color: #333;
      &:hover {
        color: #57a3f3;
      }

      img {
        width: 25px;
        height: 25px;
        border-radius: 100%;
      }
    }
    .content{
      font-size: 14px;
      word-wrap: break-word;
      word-break: break-all;
      overflow: hidden;
    }
    .pagination {
      margin-top: 20px;
    }
  }
  .send-button {
    text-align: right;
    margin-top: 10px;
  }
} 
</style>