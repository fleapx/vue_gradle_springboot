<template>
  <div class="log-layout">
    <el-table class="table-block" :data="data1" border @row-dblclick="dblclick">
      <el-table-column prop="location" label="发生位置"></el-table-column>
      <el-table-column prop="message" label="报错信息"></el-table-column>
      <el-table-column prop="createTime" label="发生时间"></el-table-column>
      <el-table-column label="查看" width="100" align="center">
        <template slot-scope="scope">
          <el-button type="primary" icon="el-icon-view" circle size="small" @click="entityInfo(scope.row)"></el-button>
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

    <!--查看modal--> 
    <el-dialog title="查看" :visible.sync="modal" width="600px" :close-on-click-modal="false">
      <el-form label-width="80px" size="small">
        <el-form-item label="用户名:">
          <span>{{entity.location}}</span>
        </el-form-item>
        <el-form-item label="内容:">
          <span>{{entity.message}}</span>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button type="primary" @click="modal = false">关 闭</el-button>
      </span>
    </el-dialog>

  </div>
</template>
<script>
export default {
  data() {
    return {
      /*修改modal的显示参数*/
      modal: false,
      /*分页total属性绑定值*/
      total: 0,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      entity: {
        location: null,
        message: null,
        createTime: null
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
    entitySet(e) {
      this.entity.location = e.location;
      this.entity.message = e.message;
      this.entity.createTime = e.createTime;
    },
    /*得到表数据*/
    getTable(e) {
      this.axios({
        method: "get",
        url: "/logs",
        params: {
          pageIndex: e.pageInfo.page,
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
    /*modal的cancel点击事件*/
    cancel() {
      this.modal = false;
    },
    /*表格中双击事件*/
    dblclick(e) {
      this.entitySet(e);
      this.modal = true;
    },
    entityInfo(e) {
      this.entitySet(e);
      this.modal = true;
    }
  }
};
</script>
<style lang="scss" scoped>
.log-layout {
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