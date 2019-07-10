<template>
  <div class="article-layout">
    <div class="search-block">
      <el-row :gutter="24">
        <el-col :span="8">
          搜索：
          <el-input class="search-input" v-model="searchContent" placeholder="请输入..." size="small"></el-input>
        </el-col>
        <el-col :span="8">
          <el-date-picker v-model="date" type="date" placeholder="选择日期" size="small"></el-date-picker>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" icon="el-icon-search" round size="small" @click="search">搜索</el-button>
        </el-col>
      </el-row>
    </div>
    <el-switch class="switch" v-model="del" @change="switchChange" active-text="已删除" inactive-text="未删除"></el-switch>
    <el-divider></el-divider>

    <div class="action-block">
      <el-button type="primary" icon="el-icon-top" size="small" @click="top(1)">置顶</el-button>
      <el-button type="warning" icon="el-icon-close" size="small" @click="top(0)">取消置顶</el-button>
      <el-button v-if="del" type="success" icon="el-icon-delete" size="small" @click="republish">恢复</el-button>
      <el-button v-if="!del" type="danger" icon="el-icon-delete" size="small" @click="clickDel">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="id" label="文章ID" width="75"></el-table-column>
      <el-table-column prop="userid" label="创建者ID" width="90"></el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="140"></el-table-column>
      <el-table-column prop="title" label="标题" width="150"></el-table-column>
      <el-table-column label="置顶" width="70" align="center">
        <template slot-scope="scope">
          <i v-if="scope.row.top == 1" class="el-icon-check check-icon"></i>
          <i v-if="scope.row.top == 0" class="el-icon-close close-icon"></i>
        </template>
      </el-table-column>
      <el-table-column prop="info" label="简介"></el-table-column>
      <el-table-column label="查看" width="100" align="center">
        <template slot-scope="scope">
          <a :href="$store.state.domainName + '/article/detail/' + scope.row.id" target="_blank">
            <el-button type="primary" icon="el-icon-view" circle size="small"></el-button>
          </a>
        </template>
      </el-table-column>
    </el-table>

    <el-pagination
      class="pagination-block"
      background
      layout="total, prev, pager, next"
      :total="total"
      :page-size="pageInfo.pageSize"
      @current-change="e=>{pageSearch(e)}">
    </el-pagination>
  </div>
</template>
<script>
export default {
  data() {
    return {
      date:null,
      searchContent:null,
      del:false,
      groupId: [],
      /*分页total属性绑定值*/
      total: 0,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      /*表数据*/
      data1: []
    };
  },
  mounted() {
    /*页面初始化调用方法*/
    this.getTable({
      pageInfo: this.pageInfo
    });
  },
  methods: {
    /*pageInfo实体初始化*/
    initPageInfo() {
      this.pageInfo.page = 0;
      this.pageInfo.pageSize = 10;
    },
    /*得到表数据*/
    getTable(e) {
      var dateTimestamp = null;
      if(this.date != null && this.date != ''){
        dateTimestamp = this.date.getTime();
      }
      var delSign = 0;
      if(this.del){
        delSign = 1;
      }
      this.axios({
        method: "get",
        url: "/admin/articles",
        params: {
          dateTimestamp: dateTimestamp,
          searchContent: this.searchContent,
          del: delSign,
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize
        }
      })
        .then(
          function(response) {
            this.data1 = response.data.data.data;
            this.total = response.data.data.totalCount;
            for (var i = this.data1.length - 1; i >= 0; i--) {
              this.data1[i].createTime = this.dateGet(this.data1[i].createTime);
            }
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    search() {
      this.initPageInfo();
      this.getTable({
        pageInfo: this.pageInfo
      });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo
      });
    },
    clickDel() {
      if (this.groupId != null && this.groupId != "") {
        this.axios({
          method: "delete",
          url: "/admin/articles",
          data: this.groupId
        })
          .then(
            function(response) {
              this.getTable({
                pageInfo: this.pageInfo
              });
              this.groupId = [];
              this.$message.info("删除成功");
            }.bind(this)
          )
          .catch(function(error) {
            alert(error);
          });
      }
    },
    republish() {
      if (this.groupId != null && this.groupId != "") {
        this.axios({
          method: "patch",
          url: "/admin/articles",
          data: this.groupId
        })
        .then(
          function(response) {
            this.getTable({
              pageInfo: this.pageInfo
            });
            this.groupId = [];
            this.$message.info("重新发布成功");
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
      }
    },
    change(e) {
      this.setGroupId(e);
    },
    setGroupId(e) {
      this.groupId = [];
      for (var i = 0; i <= e.length - 1; i++) {
        this.groupId.push(e[i].id);
      }
    },
    switchChange(){
      this.groupId = [];
      this.getTable({
        pageInfo: this.pageInfo
      });
    },
    top(e){
      this.axios({
        method: "patch",
        url: "/admin/articles/top",
        data: this.groupId,
        params: {
          top: e
        }
      })
      .then(
        function(response) {
          this.getTable({
            pageInfo: this.pageInfo
          });
          this.groupId = [];
          this.$message.info("修改成功");
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
    }
  }
};
</script>
<style lang="scss" scoped>
.check-icon {
  font-size: 24px;
  color: #67C23A;
  font-weight: bold;
}
.close-icon {
  font-size: 24px;
  color: #F56C6C;
  font-weight: bold;
}
.article-layout {
  background-color: #fff;
  padding: 20px;

  .search-block {

    .search-input {
      width: 200px;
    }
  }
  .switch {
    margin-top: 20px;
  }

  .action-block {
    margin-bottom: 10px;
  }
  .table-block {
    margin-bottom: 10px;
  }
  .pagination-block {
    text-align: right;
  }
}
</style>