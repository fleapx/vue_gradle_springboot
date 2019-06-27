<template>
    <div class="unread-msg-wrapper">
      <el-card shadow="hover" v-for="(item, index) in messages" :key="item.id" class="msg-card-item" @click.native="read(item.id,item.isread)">
        <el-row :gutter="24">
          <el-col :span="24" class="synopsis">
            <el-avatar shape="square" size="small" :src="item.replyUserHeadimg"></el-avatar>
            <span class="user-name">{{item.replyUsername}}</span>
            <span class="time">{{dateGet(item.replytime)}}</span>
            <span>回复：</span>

            <router-link v-if="item.form == 0" :to="{ path: '/page/card/' + item.toId }">{{item.title}}</router-link>
            <router-link v-if="item.form == 1" :to="{ path: '/article/detail/' + item.toId }">{{item.title}}</router-link>
          </el-col>
        </el-row>
        <el-divider></el-divider>
        <div class="reply-content">
            <p>{{item.replyContent}}</p>
        </div>
        <i v-if="item.isread == 0" class="el-icon-view unread-symbol"></i>
      </el-card>

      <el-pagination
        hide-on-single-page
        class="pagin"
        background
        layout="total, prev, pager, next"
        :total="totalCount"
        :page-size="pageSize"
        @current-change="e=>{pageSearch(e)}">
      </el-pagination>

    </div>
</template>

<script>
export default {
  name: "messages",

  data() {
    return {
      messages: [],
      pageSize: 10,
      page: 0,
      totalCount: 0
    };
  },

  mounted() {
    let _this = this;
    this.axios
      .get(
        "/msgrecords/user?pageSize= " + _this.pageSize + "&page=" + _this.page
      )
      .then(function(response) {
        let data = response.data.data;
        _this.messages = data.data;
        _this.totalCount = data.totalCount;
        console.log(_this.messages);
      })
      .catch(function(error) {
        _this.$messages({
          messages: '查询失败，请稍后重试',
          type: 'error'
        });
      });
  },

  methods: {
    read(id, isread) {
      console.log('read');
      if (isread == 1) {
        return;
      }
      let _this = this;
      this.axios({
        method: "put",
        url: "/msgrecords/read/",
        params: {
          msgRecordId: id
        }
      })
        .then(
          function(response) {
            let index = _this.messages.findIndex(function(item) {
              return item.id == id;
            });

            let item = _this.messages[index];
            item.isread = 1;

            _this.messages.splice(index, 1, item);
          }.bind(this)
        )
        .catch(function(error) {
          _this.$messages({
            messages: '已读失败，请稍后重试',
            type: 'error'
          });
        });
    },
    pageSearch(e) {
      this.page = e - 1;
      let _this = this;
    this.axios
      .get(
        "/msgrecords/user?pageSize= " + _this.pageSize + "&page=" + _this.page
      )
      .then(function(response) {
        let data = response.data.data;
        _this.messages = data.data;
        _this.totalCount = data.totalCount;
      })
      .catch(function(error) {
        _this.$messages({
            messages: '查询失败，请稍后重试',
            type: 'error'
          });
      });
    }
  }
};
</script>

<style scoped lang="scss">
.unread-msg-wrapper {
  background: #fff;
  padding: 20px;
  width: 80%;
  margin: 0 auto;
  position: relative;
  font-size: 14px;

  .msg-card-item {
    position: relative;
  }

  .unread-symbol {
    font-size: 18px;
    color: red;
    position: absolute;
    top: 1.5em;
    right: 1em;
  }

  .synopsis {
    span {
      line-height: 30px;
      margin-right: 10px;
    }
  }

  .reply-content {
    padding: 6px 30px;

    p {
      word-wrap: break-word;
      word-break: break-all;
      overflow: hidden;
    }
  }

  .pagin {
    margin: 10px 20px;
  }
}
</style>
