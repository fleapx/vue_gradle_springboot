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
          <a :href="$store.state.userUrlPre+item.userid" target="_blank" class="user-info">
            <img :src="item.headimg">
          </a>
          <div class="user-info">
            <a class="user-name" :href="$store.state.userUrlPre+item.userid" target="_blank">
              {{item.username}}
            </a>
            <p class="post-time">
              {{item.replytime}}
            </p>
          </div>
          <div class="chat">
            <i class="el-icon-chat-line-round"></i>
            <span>{{item.replyCount}}</span>
          </div>
        </div>
        <div>
          <router-link :to="('/mobile/card/'+item.id)">
              <span class="title-text">{{item.title}}</span>
          </router-link>
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
      <div class="send-card-sub">
        <span><i class="el-icon-edit-outline"></i>发帖</span>
      </div>
      <div class="send-card-sub">
        <el-input v-model="title" placeholder="标题"></el-input>
      </div>
      <div class="send-card-sub">
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
    dateGet(e) {
      var time = new Date(parseInt(e));
      return (
        time.getFullYear() +
        "-" +
        (time.getMonth() + 1) +
        "-" +
        time.getDate() +
        " " +
        time.getHours() +
        ":" +
        time.getMinutes()
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
                this.$message.info("发帖成功");
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
          this.$message.error("登录后，才能发帖！");
        }
      } else {
        this.$message.error("请填写标题和内容");
      }
    }
  }
};
</script>
<style type="text/css" scoped>
.detail-layout {
  background: #fff;
  margin: 10px 0;
}
.detail-layout .interest-title {
    font-size: 220%;
    line-height: 50px;
    text-align: center;
    padding: 10px 0;
}
.detail-layout .interest-content {
  border: 0;
  border-top: 1px solid #ccc;
}
.post-card {
  padding: 0 15px;
  margin: 50px 0;
}
.post-card .post-card-head {
  background: #eceef2;
  border-bottom: 1px solid #e8eaec;
  padding: 14px 16px;
  line-height: 1;
}
.post-card .post-card-head p {
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
.post-card .chat{
float: right;
display: inline;
color:#f90;
}
.post-card .chat i {
  font-size: 25px;
}

.post-card .chat span{
  margin-left: 2px;
  font-size: 14px;
}
.post-card .user-info {
  float: left;
  font-size: 14px;
  color: #333;
  margin-right: 5px;
}
.post-card .user-info img {
  width: 40px;
  height: 40px;
  border-radius: 100%;
}
.post-card .user-info .user-name {
  font-size: 17px;
}
.post-card .user-info .post-time {
  font-size: 12px;
}
.pagination {
  margin-top: 10px;
}
.send-card {
  padding: 0 15px;
}
.send-card .send-card-sub {
  padding: 5px 0;
}
.send-button {
  margin-top: 10px;
  margin-left: 15px;
  padding-bottom: 10px;
}

.clearfix:after {
  visibility: hidden;
  display: block;
  font-size: 0;
  content: ".";
  clear: both;
  height: 0;
}
.clearfix {
  zoom: 1;
}
.head {
  border-bottom: 1px solid #e8eaec;
}
.layout-left {
  float: left;
}
.content p{
  word-wrap: break-word;
  word-break: break-all;
  overflow: hidden;
}
.chat {
  color:#f90;
  float: right;
}
</style>