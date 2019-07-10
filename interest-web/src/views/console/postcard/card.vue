<template>
  <div class="card-layout">

    <div class="search-block">
      <el-row :gutter="24">
        <el-col :span="8">
          兴趣：
          <el-select class="search-select" v-model="interestid" placeholder="请选择" clearable size="small">
            <el-option v-for="item in interestList" :key="item.id" :label="item.title" :value="item.id"></el-option>
          </el-select>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" icon="el-icon-search" round size="small" @click="search">搜索</el-button>
        </el-col>
      </el-row>
    </div>

    <el-divider></el-divider>

    <div class="action-block">
      <el-button type="danger" icon="el-icon-delete" size="small" @click="del">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change" @row-dblclick="dblclick">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="username" label="登录名"></el-table-column>
      <el-table-column prop="interestName" label="所在兴趣"></el-table-column>
      <el-table-column prop="title" label="标题" width="500"></el-table-column>
      <el-table-column prop="createtime" label="时间"></el-table-column>
      <el-table-column label="查看" align="center" width="100">
        <template slot-scope="scope">
          <a :href="$store.state.domainName + '/page/card/' + scope.row.id" target="_blank">
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

    <!--查看modal--> 
    <el-dialog title="查看" :visible.sync="modal" width="600px" :close-on-click-modal="false">
      <el-form label-width="80px" size="small">
        <el-form-item label="登录名:">
          <strong>{{postcard.username}}</strong>
        </el-form-item>
        <el-form-item label="内容:">
          <span>{{postcard.content}}</span>
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
      groupId: [],
      interestid: null,
      interestList: [],
      /*修改modal的显示参数*/
      modal: false,
      /*分页total属性绑定值*/
      total: 0,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      /*user实体*/
      postcard: {
        id: null,
        username: null,
        title: null,
        interestid: null,
        content: null,
        createtime: null,
        replytime: null
      },
      /*表数据*/
      data1: []
    };
  },
  mounted() {
    /*页面初始化调用方法*/
    this.axios({
      method: "get",
      url: "/public/interests"
    })
      .then(
        function(response) {
          this.interestList = response.data.data;
          this.getTable({
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
  },
  methods: {
    /*pageInfo实体初始化*/
    initPageInfo() {
      this.pageInfo.page = 0;
      this.pageInfo.pageSize = 10;
    },
    postcardSet(e) {
      this.postcard.id = e.id;
      this.postcard.username = e.username;
      this.postcard.title = e.title;
      this.postcard.interestid = e.interestid;
      this.postcard.content = e.content;
      this.postcard.createtime = e.createtime;
      this.postcard.replytime = e.replytime;
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
    /*得到表数据*/
    getTable(e) {
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
            this.data1 = response.data.data.data;
            this.data1.forEach(e => {
              this.interestList.forEach(interest => {
                if (e.interestid == interest.id) {
                  e.interestName = interest.title;
                }
              });
            });
            this.listDateSet(this.data1);
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    search() {
      this.initPageInfo();
      this.getTable({
        pageInfo: this.pageInfo,
        interestid: this.interestid
      });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo,
        interestid: this.interestid
      });
    },
    /*modal的cancel点击事件*/
    cancel() {
      this.modal = false;
    },
    /*表格中双击事件*/
    dblclick(e) {
      this.postcardSet(e);
      this.modal = true;
    },
    postcardInfo(e) {
      console.log(e);
      this.postcardSet(e);
      this.modal = true;
    },
    del() {
      if (this.groupId != null && this.groupId != "") {
        this.axios({
          method: "delete",
          url: "/postcards",
          data: this.groupId
        })
          .then(
            function(response) {
              this.getTable({
                pageInfo: this.pageInfo,
                interestid: this.interestid
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
.card-layout {
  background-color: #fff;
  padding: 20px;

  .search-block {
    

    .search-select {
      width: 200px;
    }
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