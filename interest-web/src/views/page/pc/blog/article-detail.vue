<template>
    <div id="article_detail" class="article-detail">
      <div class="">
          <div class="article">
              <div class="ql-container ql-snow">
                  <div class="ql-editor">
                      <div class="title">{{article.title}}</div>
                      <dl class="list-user-other">
                          <dt>
                              <a :href="$store.state.userUrlPre+article.userid" target="_blank">
                                <el-avatar :src="article.userHeadImg" size="small"></el-avatar>
                              </a>
                          </dt>
                          <dd>
                              <a :href="$store.state.userUrlPre+article.userid" target="_blank">{{article.userName}}</a>
                          </dd>
                          <dd>
                              <span class="text">阅读数:</span>
                              <span class="num">{{article.clickRate}}</span>
                          </dd>
                          <dd>{{article.createTime}}</dd>
                      </dl>
                      <el-divider></el-divider>
                      <div class="content" v-html="article.content"></div>
                  </div>
              </div>
          </div>
          <el-divider></el-divider>
          <div class="comment-append-section" id="commentAppendArea">
            <el-input 
              v-model="commentAppend"
              @blur="toggleInput"
              @focus="focusInput"
              ref="commentInputDom"
              type="textarea"
              :rows="commentAppendInput"
              placeholder="添加评论"></el-input>

            <el-button class="publish-button" type="primary" @click="publishComment()" size="small">发表评论</el-button>
          </div>

          <div class="comment-section">

              <ul class="reply-list">
                  <li v-for="(comment, index) in comments" class="reply-item" :key="comment.id">
                          <div class="user">
                              <a :href="$store.state.userUrlPre+comment.userid" target="_blank">
                                  <img class="avatar" :src="comment.userHeadImg" :title="comment.userName" />
                              </a>
                              <div class="title-info">
                                  <a :href="$store.state.userUrlPre+comment.userid" target="_blank">
                                      <span class="user-name">{{comment.userName}}</span>
                                  </a>
                                  <span># {{index + 1}} 楼 • </span>
                                  <span v-if="comment.creatTimeBy != null">{{comment.creatTimeBy}}</span>
                                  <span v-if="comment.creatTimeBy == null">刚刚</span>
                              </div>
                              <div class="title-info-other">
                                  <span>
                                      <a v-if="comment.childCommentsCount > 0" v-show="!comment.showContent" @click="changeContent(index)">查看回复({{comment.childCommentsCount}})</a>
                                      <a v-if="comment.childCommentsCount > 0" v-show="comment.showContent" @click="changeContent(index)">收起回复</a>
                                      <a @click="writeComment(comment,1)">回复</a>
                                  </span>
                              </div>
                          </div>
                          <div class="reply-info">
                              <div class="reply-content">
                                  {{comment.comment}}
                              </div>
                          </div>
                      <ul v-show="comment.showContent" class="reply-child-list">
                          <li v-for="(replyComment,replyIndex) in comment.childComments" class="reply-item" :key="replyComment.id">
                              <div class="reply-info">
                                  <div class="title-info">
                                      <a :href="$store.state.userUrlPre+replyComment.userid" target="_blank">
                                          <img class="avatar" :src="replyComment.userHeadImg" :title="replyComment.userName" />
                                      </a>
                                      <div class="title-info-right">
                                          <a :href="$store.state.userUrlPre+replyComment.userid" target="_blank">
                                              <span class="user-name">{{replyComment.userName}}</span>
                                          </a>
                                          <span>回复</span>
                                          <span class="user-name">{{replyComment.replierName}}:</span>
                                          <span>{{replyComment.comment}}</span>
                                          <span v-if="replyComment.creatTimeBy != null" class="reply-time">({{replyComment.creatTimeBy}})</span>
                                          <span v-if="replyComment.creatTimeBy == null" class="reply-time">(刚刚)</span>
                                          <a @click="writeComment(replyComment,2)">回复</a>
                                      </div>
                                  </div>
                              </div>
                          </li>
                      </ul>
                  </li>
              </ul>
              <el-pagination
                hide-on-single-page="true"
                class="paging"
                layout="total, prev, pager, next"
                :total="total"
                :page-size="pageSize"
                @current-change="e=>{pageSearch(e)}">
              </el-pagination>
          </div>
      </div>
    </div>
</template>
<script>
export default {
  name: 'article_detail',
  data() {
      return {
          articleId: null,
          article: {
              id: "",
              title: "",
              content: "",
              clickRate: "",
              commentCount: "",
              createTime: "",
              userid: "",
              userName: "",
              userHeadImg: "",
              githuburl: ""
          },
          comments: [],
          page: 0,
          pageSize: 10,
          total: 0,
          commentAppend: '',
          commentAppendInput:1,
          appendActive: false,
          articleComment: {
              articleid: null,
              articleOwnerId:null,
              parentid: null,
              comment: null,
              replierId: null,
              replierName: null
          }
      };
  },
  mounted() {
      this.articleId = this.$route.params.id;
      this.getArticle(this.$route.params.id);
      this.getComments();
  },
  methods: {
      getArticle(e) {
          this.axios({
              method: "get",
              url: "/public/articles/article/" + e
          }).then(
              function (response) {
                  this.articleSet(response.data.data);
              }.bind(this)
          ).catch(
              function (error) {

              }.bind(this)
          );
      },
      articleSet(e) {
          this.article.id = e.id;
          this.article.title = e.title;
          this.article.content = e.content;
          this.article.clickRate = e.clickRate;
          this.article.commentCount = e.commentCount;
          this.article.createTime = this.dateGet(e.createTime);
          this.article.userid = e.userid;
          this.article.userName = e.userName;
          this.article.userHeadImg = e.userHeadImg;
          this.article.githuburl = e.githuburl;
      },
      articleCommentSet(e) {
          this.articleComment.articleid = e.articleid;
          this.articleComment.parentid = e.parentid;
          this.articleComment.comment = e.comment;
          this.articleComment.replierId = e.replierId;
          this.articleComment.replierName = e.replierName;
          this.articleComment.articleOwnerId = this.article.userid;
      },
      articleCommentInit() {
          this.articleComment.articleid = null;
          this.articleComment.parentid = null;
          this.articleComment.comment = null;
          this.articleComment.replierId = null;
          this.articleComment.replierName = null;
          this.articleComment.articleOwnerId = null;
      },
      getComments() {
          this.axios({
              method: 'get',
              url: '/public/article/comment',
              params: {
                  articleId: this.articleId,
                  page: this.page,
                  pageSize: this.pageSize
              },
          }).then(
              function (response) {
                  let data = response.data.data;
                  for (let comment of data.data) {
                      comment.creatTimeBy = this.latestTimeFormat(comment.createTime)
                      comment.showContent = false;
                      for (let replyComment of comment.childComments) {
                          replyComment.creatTimeBy = this.latestTimeFormat(replyComment.createTime);
                      }
                  }
                  this.comments = data.data;
                  this.total = data.totalCount;
              }.bind(this)
          ).catch(function (error) {

              }.bind(this)
          );
      },
      focusInput(event){
          this.commentAppendInput = 3;
      },
      writeComment(e,sign){
          this.commentAppendInput = 3;

          var anchor = this.$el.querySelector("#commentAppendArea")
          document.body.scrollTop = anchor.offsetTop; // chrome
          this.appendActive = true;
          //document.documentElement.scrollTop = anchor.offsetTop; // firefox

          if(sign == 1){
              this.articleComment.articleid = this.articleId;
              this.articleComment.parentid = e.id;
              this.articleComment.comment = null;
              this.articleComment.replierId = e.userid;
              this.articleComment.replierName = e.userName;
          }else if(sign == 2){
              this.articleComment.articleid = this.articleId;
              this.articleComment.parentid = e.parentid;
              this.articleComment.comment = null;
              this.articleComment.replierId = e.userid;
              this.articleComment.replierName = e.userName;
          }
          this.commentAppend = "[reply]"+e.userName+"[/reply]\n";
      },
      publishComment() {
          if (this.axios.defaults.headers.common["Authorization"] == null ||this.axios.defaults.headers.common["Authorization"] == ""){
              this.$message({
                message: '请登录',
                type: 'error'
              });
              return;
          }
          if(this.commentAppend == null || this.commentAppend == ''){
              this.$message({
                message: '请输入评论',
                type: 'error'
              });
              return;
          }

          if(this.articleComment.replierName != null){
              var str = this.commentAppend.substring(0,15+this.articleComment.replierName.length);
              var validate = "[reply]"+this.articleComment.replierName+"[/reply]";
              if(str == validate){
                  this.articleComment.comment = this.commentAppend.substring(str.length);
                  this.articleComment.articleOwnerId = this.article.userid;
                  this.postComment(this.articleComment);
              }else {
                  this.postComment({
                  articleid:this.articleId,
                  comment:this.commentAppend,
                  articleOwnerId:this.article.userid});
              }
          }else {
              this.postComment({
                  articleid:this.articleId,
                  comment:this.commentAppend,
                  articleOwnerId:this.article.userid});
          }
      },
      postComment(e){
          this.axios({
              method: 'post',
              url: '/article/comment',
              data: e
          }).then(function (response) {
              this.$message({
                message: '评论成功',
                type: 'success'
              });
              this.getComments();
              this.articleCommentInit();
              this.commentAppend = null;
          }.bind(this)).catch(function () {
              this.$message({
                message: '评论失败，请稍后重试！',
                type: 'error'
              });
          }.bind(this));
      },
      changeContent(index){
          var temp = this.comments[index];
          temp.showContent = ! temp.showContent;
          this.comments.splice(index,1,temp);
      },
      pageSearch(e) {
        this.page = e - 1;
        this.getComments();
      }
  }
};
</script>
<style scoped lang="scss">
.publish-button {
  margin-top: 10px;
}
.ql-container.ql-snow {
  border: 0;
}
.article-detail {
  width: 80%;
  margin: 0 auto;
  background-color: #fff;
  padding: 20px;
}
.article {
    width: 100%;
    background: #fff;
    margin-bottom: 20px;
}

.title {
  color: black;
  line-height: 40px;
  font-size: 220%;
}

.list-user-other {
    margin: 10px 0px;
    height: 24px;
    line-height: 24px;
}

.list-user-other dt {
    float: left;
    margin: 0 6px 0 0;
}

.list-user-other dd {
    float: left;
    font-size: 14px;
    color: #8a8a8a;
    line-height: 24px;
    margin-right: 10px;
}

.list-user-other .text {
    margin-right: 4px;
    color: #8a8a8a;
}

.list-user-other .num {
    color: #3399ea;
}

.content {
    overflow: hidden;
}
.content img{
    max-width: 100%;
}

.comment-section {
    flex-direction: column;
    margin-top: 5px;
    background-color: #fff;
    overflow: hidden;

    ul {
        list-style: none;
    }

    image {
        margin-right: 10px;
        border-radius: 6px;

    }

    .avatar {
        margin-right: 6px;
        border-radius: 20px;
        width: 26px;
        height: 26px;
    }

    .reply-count {
        padding: 12px 15px;
        background-color: #eee;
    }

    .reply-list {
        display: flex;
        flex-direction: column;

        .reply-item {
            display: flex;
            padding: 12px 15px;
            border-bottom: 1px solid #f0f0f0;
            flex-direction: column;

            .user {
                flex: 0 0 26px;

                .avatar {
                    margin-right: 6px;
                    border-radius: 20px;
                    width: 26px;
                    height: 26px;
                    float: left;
                }
                .title-info {
                    font-size: 12px;
                    float:left;
                    margin-top: 4px;

                    .user-name {
                        margin: 0 4px;
                        color: #666;

                        &:hover {
                            color: #385f8a;
                        }
                    }
                }
                .title-info-other {
                    font-size: 12px;
                    float:left;
                    margin: 4px 0 0 20px;

                    a {
                        margin: 0 5px;
                    }
                }
            }
            .reply-child-list {
                margin-left: 32px;
                border-left: 4px solid #c5c5c5;

                .title-info {
                    font-size: 12px;
                    float:left;
                    margin-top: 4px;

                    .user-name {
                        margin: 0 4px;
                        color: #666;

                        &:hover {
                            color: #385f8a;
                        }
                    }
                    .avatar {
                        margin-right: 6px;
                        border-radius: 20px;
                        width: 26px;
                        height: 26px;
                        float: left;
                    }
                    .title-info-right {
                        float: left;
                        margin-top: 4px;

                        .reply-time {
                            padding: 0 20px;
                        }
                    }
                }
            }
        }

        .reply-hightlight {
            background-color: #f4fcf0;
        }

        .reply-info {
            display: flex;
            flex-direction: column;

            text {
                margin-left: 20px;
            }
        }

        .up-info {
            flex-grow: 1;
            justify-content: flex-end;
            color: #808080;

            image {
                width: 50px;
                height: 50px;
            }

            .up-count {
                margin-left: 0;
            }

        }
    }

    .reply-content {
        padding: 10px 20px 0 0;
        font-size: 14px;
    }

    .pagin {
        margin: 10px 15px;
    }
}
</style>