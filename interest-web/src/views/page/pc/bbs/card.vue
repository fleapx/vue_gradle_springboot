<template>
  <div class="card-layout">

    <div class="card-head">
      <p>{{postcard.title}}</p>
    </div>

    <el-card shadow="never">
      <el-row :gutter="24">
        <el-col :span="20" class="content-text">
          <p>{{postcard.content}}</p>
          <span>
            <i class="el-icon-time"></i>
            {{postcard.createtime}}
          </span>
        </el-col>
        <el-col :span="4" class="user-info">
          <div>
            <a :href="$store.state.userUrlPre+postcard.userid" target="_blank">
              <img :src="postcard.headimg">
              {{postcard.username}}
            </a>
          </div>
          <div class="first-floor">
            楼主
          </div>
        </el-col>
      </el-row>
    </el-card>

    <el-card v-for="(item,index) in replyCardList" :key="index" shadow="never">
      <el-row :gutter="24">
        <el-col :span="20" class="content-text">
          <p>{{item.content}}</p>
          <span>
            <i class="el-icon-time"></i>
            {{item.createtime}}
          </span>
        </el-col>
        <el-col :span="4" class="user-info">
          <div>
            <a :href="$store.state.userUrlPre+item.userid" target="_blank">
              <img :src="item.headimg">
              {{item.username}}
            </a>
          </div>
        </el-col>
      </el-row>
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

    <div class="send-reply-card">
      <div class="reply-title">
        <span><i class="el-icon-edit-outline"></i>回复</span>
      </div>
      <div class="reply-content">
        <el-input v-model="textarea" type="textarea" rows="6" placeholder="内容"></el-input>
      </div>
      <div class="send-button">
        <el-button type="primary" @click="sendCard()">发送</el-button>
      </div>
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
        username: "",
        title: "",
        content: "",
        interestid: "",
        createtime: "",
        headimg: "",
        githuburl: "",
        userid: ""
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

    listDateSet(e) {
      for (var i = e.length - 1; i >= 0; i--) {
        e[i].createtime = this.dateGet(e[i].createtime);
      }
    },
    postcardSet(e) {
      this.postcard.id = e.id;
      this.postcard.username = e.username;
      this.postcard.title = e.title;
      this.postcard.content = e.content;
      this.postcard.interestid = e.interestid;
      // this.postcard.createtime = e.createtime;
      this.postcard.createtime = this.dateGet(e.createtime);
      this.postcard.headimg = e.headimg;
      this.postcard.githuburl = e.githuburl;
      this.postcard.userid = e.userid;
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
                this.$message({
                  message: '回复成功',
                  type: 'success'
                });
                this.textarea = "";
                this.replyCardListGet({
                  pageInfo: this.pageInfo,
                  postcardid: this.postcardid
                });
              }.bind(this)
            )
            .catch(
              function(error) {
                this.$message({
                  message: '请重新登录',
                  type: 'error'
                });
              }.bind(this)
            );
        } else {
          this.$message({
            message: '登录后，才能回复！',
            type: 'error'
          });
        }
      } else {
        this.$message({
            message: '请填写回复内容',
            type: 'error'
          });
      }
    }
  }
};
</script>
<style lang="scss" scoped>
.card-layout {
  background: #fff;
  padding: 20px;
  width: 80%;
  margin: 0 auto;

  .card-head {
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

  .content-text{
    font-size: 14px;
    border-right: 1px solid #e8eaec;

    p{
      word-wrap: break-word;
      word-break: break-all;
      overflow: hidden;
    }
  }

  .user-info {
    text-align: center;

    img {
      width: 25px;
      height: 25px;
      border-radius: 100%;
    }

    .first-floor {
      background: #5cadff;
      text-align: center;
      color: #fff;
      border-radius: 10px;
    }
  }

  .pagination {
    margin-top: 20px
  }
  .send-reply-card {

    .reply-title {
      padding: 5px;
    }

    .reply-content {
      padding: 5px;
    }
    .send-button {
      text-align: right;
      margin-top: 10px;
    }
  }
}
</style>