<template>
    <div class="card-layout">
      <div class="card-title">
          <p>{{postcard.title}}</p>
      </div>
      <el-card shadow="hover">
        <div slot="header" class="clearfix">
          <a :href="$store.state.userUrlPre+postcard.userid" target="_blank" class="user-info">
            <img :src="postcard.headimg">
          </a>
          <div class="user-info">
            <a class="user-name" :href="$store.state.userUrlPre+postcard.userid" target="_blank">
              {{postcard.username}}
            </a>
            <p class="post-time">
              {{postcard.createtime}}
            </p>
          </div>
        </div>
        <div>
          <span class="post-content">{{postcard.content}}</span>
        </div>
      </el-card>

      <el-card v-for="(item,index) in replyCardList" :key="index" shadow="hover">
        <div slot="header" class="clearfix">
          <a :href="$store.state.userUrlPre+item.userid" target="_blank" class="user-info">
            <img :src="item.headimg">
          </a>
          <div class="user-info">
            <a class="user-name" :href="$store.state.userUrlPre+item.userid" target="_blank">
              {{item.username}}
            </a>
            <p class="post-time">
              {{item.createtime}}
            </p>
          </div>
        </div>
        <div>
          <span class="post-content">{{item.content}}</span>
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
      <el-divider></el-divider>
      <div class="send-card">
        <div class="send-card-sub">
          <span><i class="el-icon-edit-outline"></i>发表回复</span>
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
      total: 0,
      pageInfo: {
        page: 0,
        pageSize: 20
      },
      textarea: "",
      postcardid: null,
      postcard: {
        id: "",
        userid: null,
        username: "",
        title: "",
        content: "",
        interestid: "",
        createtime: "",
        headimg: "",
        githuburl: ""
      },
      replyCardList: []
    };
  },
  mounted() {
    this.postcardid = this.$route.params.id;
    this.axios({
      method: "get",
      url: "/public/postcards/postcard",
      params: {
        id: this.postcardid
      }
    })
      .then(
        function(response) {
          this.postcardSet(response.data.data);
        }.bind(this)
      )
      .catch(
        function(error) {
          alter(error);
        }.bind(this)
      );
    this.replyCardListGet({
      pageInfo: this.pageInfo,
      postcardid: this.postcardid
    });
  },
  methods: {
    replyCardListGet(e) {
      this.axios({
        method: "get",
        url: "/public/replycards",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          postcardid: e.postcardid
        }
      })
        .then(
          function(response) {
            this.replyCardList = response.data.data.data;
            this.listDateSet(this.replyCardList);
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
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
        e[i].createtime = this.dateGet(e[i].createtime);
      }
    },
    postcardSet(e) {
      this.postcard.id = e.id;
      this.postcard.username = e.username;
      this.postcard.userid = e.userid;
      this.postcard.title = e.title;
      this.postcard.content = e.content;
      this.postcard.interestid = e.interestid;
      // this.postcard.createtime = e.createtime;
      this.postcard.createtime = this.dateGet(e.createtime);
      this.postcard.headimg = e.headimg;
      this.postcard.githuburl = e.githuburl;
    },
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.replyCardListGet({
        pageInfo: this.pageInfo,
        postcardid: this.postcardid
      });
    },
    sendCard() {
      if (this.textarea != null && this.textarea != "") {
        if (
          this.axios.defaults.headers.common["Authorization"] != null &&
          this.axios.defaults.headers.common["Authorization"] != ""
        ) {
          this.axios({
            method: "post",
            url: "/replycards/replycard",
            data: {
              postcardid: this.postcardid,
              content: this.textarea
            }
          })
            .then(
              function(response) {
                this.$message.info("回复成功");
                this.textarea = "";
                // this.pageInfo.page = 0;
                this.replyCardListGet({
                  pageInfo: this.pageInfo,
                  postcardid: this.postcardid
                });
              }.bind(this)
            )
            .catch(
              function(error) {
                this.$message.error("请重新登录");
              }.bind(this)
            );
        } else {
          this.$message.error("登录后，才能回复！");
        }
      } else {
        this.$message.error("请填写回复内容");
      }
    }
  }
};
</script>
<style type="text/css" scoped>
.card-layout {
  background: #fff;
  margin: 10px 0;
  padding: 10px;
}
.card-layout .card-title {
  background: #eceef2;
  border-bottom: 1px solid #e8eaec;
  padding: 14px 16px;
  line-height: 1;
}
.card-layout .card-title p {
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
.user-info {
  float: left;
  font-size: 14px;
  color: #333;
  margin-right: 5px;
}
.user-info img {
  width: 40px;
  height: 40px;
  border-radius: 100%;
}
.user-info .user-name {
  font-size: 17px;
}
.user-info .post-time {
  font-size: 12px;
}
.post-content {
  font-size: 14px;
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
.pagination {
  margin-top: 10px;
}
.send-card {
  padding: 0 15px;
}
.send-card .send-card-sub {
  font-size: 14px;
  padding: 5px 0;
}
.send-button {
  margin-top: 10px;
  margin-left: 15px;
  padding-bottom: 10px;
}
</style>