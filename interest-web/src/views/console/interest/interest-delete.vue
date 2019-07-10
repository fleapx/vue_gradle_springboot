<template>
  <div class="interest-del-layout">
    <div class="action-block">
      <el-button type="danger" icon="el-icon-delete" size="small" @click="del">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="id" label="ID" width="100"></el-table-column>
      <el-table-column prop="title" label="标题" width="150"></el-table-column>
      <el-table-column prop="info" label="简介"></el-table-column>
      <el-table-column prop="sort" label="排序" width="100" align="center"></el-table-column>
      <el-table-column label="查看" width="100" align="center">
        <template slot-scope="scope">
          <a :href="$store.state.domainName + '/page/detail/' + scope.row.id" target="_blank">
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
      this.axios({
        method: "get",
        url: "/admin/interests",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize
        }
      })
        .then(
          function(response) {
            this.data1 = response.data.data.data;
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo
      });
    },
    del() {
      if (this.groupId != null && this.groupId != "") {
        this.axios({
          method: "delete",
          url: "/admin/interests",
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
    change(e) {
      this.setGroupId(e);
    },
    setGroupId(e) {
      this.groupId = [];
      for (var i = 0; i <= e.length - 1; i++) {
        this.groupId.push(e[i].id);
      }
    }
  }
};
</script>
<style lang="scss" scoped>
.interest-del-layout {
  background-color: #fff;
  padding: 20px;

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