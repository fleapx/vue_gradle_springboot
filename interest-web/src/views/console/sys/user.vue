<template>
  <div class="user-layout">

    <div class="search-block">
      <el-row :gutter="24">
        <el-col :span="8">
          用户名：
          <el-input class="search-input" v-model="name" placeholder="请输入..." size="small"></el-input>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" icon="el-icon-search" round size="small" @click="search">搜索</el-button>
        </el-col>
      </el-row>
    </div>

    <el-divider></el-divider>

    <div class="action-block">
      <el-button type="success" icon="el-icon-edit" size="small" @click="openModifyModal">修改</el-button>
      <el-button type="danger" icon="el-icon-delete" size="small" @click="del">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change" @row-dblclick="dblclick">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="name" label="用户名"></el-table-column>
      <el-table-column label="头像" width="80" align="center">
        <template slot-scope="scope">
          <img :src="scope.row.headimg" width="30px" height="30px">
        </template>
      </el-table-column>
      <el-table-column label="url" width="300">
        <template slot-scope="scope">
          <a :href="scope.row.url" target="_blank">
            {{scope.row.url}}
          </a>
        </template>
      </el-table-column>
      <el-table-column prop="email" label="邮箱"></el-table-column>
      <el-table-column label="用户类型" align="center">
        <template slot-scope="scope">
          <strong v-if="scope.row.usertype == 0">普通用户</strong>
          <strong v-if="scope.row.usertype == 1">管理员</strong>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="注册时间"></el-table-column>
      <el-table-column label="配置角色" align="center">
        <template slot-scope="scope">
          <el-button type="primary" icon="el-icon-setting" circle @click="relationSet(scope.row)" size="small"></el-button>
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

    <!--修改modal-->
    <el-dialog
      title="修改"
      :visible.sync="modifyModal"
      width="600px"
      :close-on-click-modal="false">
      <span>
        <el-form :model="email" :rules="emailRule" ref="email" label-width="80px">
          <el-form-item label="登录名:">
            <el-input v-model="userModify.name" :disabled="true"></el-input>
          </el-form-item>
          <el-form-item label="用户类型:">
            <el-select v-model="userModify.usertype" placeholder="请选择">
              <el-option
                v-for="item in userTypeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value">
              </el-option>
            </el-select>
          </el-form-item>
        </el-form>
      </span>
      <span slot="footer">
        <el-button @click="modifyModal = false">取 消</el-button>
        <el-button type="primary" @click="modifyOk">确 定</el-button>
      </span>
    </el-dialog>
    <!--配置角色modal--> 
    <el-dialog
      title="角色配置"
      :visible.sync="roleModal"
      width="500px"
      :close-on-click-modal="false">
      <span>
        <el-table ref="roleTable" :data="data2" border @selection-change="change2">
          <el-table-column type="selection" width="55" align="center"></el-table-column>
          <el-table-column prop="name" label="角色名称" width="120"></el-table-column>
          <el-table-column prop="describe" label="描述"></el-table-column>
        </el-table>
      </span>
      <span slot="footer">
        <el-button @click="roleModal = false">取 消</el-button>
        <el-button type="primary" @click="roleOk">确 定</el-button>
      </span>
    </el-dialog> 
  </div>
</template>
<script>
export default {
  data() {
    return {
      userTypeOptions: [{
        value: 0,
        label: '普通用户'
      },{
        value: 1,
        label: '管理员'
      }],
      /*用于查找的登录名*/
      name: null,
      /*选择的数量*/
      count: null,
      /*选中的组数据*/
      groupId: null,
      /*新建modal的显示参数*/
      newModal: false,
      /*修改modal的显示参数*/
      modifyModal: false,
      /*角色配置modal的显示参数*/
      roleModal: false,
      /*分页total属性绑定值*/
      total: 0,
      /*loading*/
      loading: true,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      /*user实体*/
      user: {
        id: null,
        name: null,
        loginName: null,
        password: null,
        passwordAgain: null,
        email: null
      },
      /*用于添加的user实体*/
      userNew: {
        id: null,
        name: null,
        loginName: null,
        password: null,
        passwordAgain: null,
        email: null
      },
      /*用于修改的user实体*/
      userModify: {
        id: null,
        name: null,
        usertype: null
      },
      /*新建验证*/
      ruleNew: {
        name: [
          {
            type: "string",
            required: true,
            message: "输入用户名",
            trigger: "blur"
          }
        ],
        loginName: [
          {
            type: "string",
            required: true,
            message: "输入登录名",
            trigger: "blur"
          }
        ],
        password: [
          {
            type: "string",
            required: true,
            message: "输入密码",
            trigger: "blur"
          }
        ],
        passwordAgain: [
          {
            type: "string",
            required: true,
            message: "输入再次密码",
            trigger: "blur"
          }
        ],
        email: [
          { required: true, message: "输入邮箱", trigger: "blur" },
          { type: "email", message: "输入正确的邮箱格式", trigger: "blur" }
        ]
      },
      /*修改验证*/
      ruleModify: {
        name: [
          {
            type: "string",
            required: true,
            message: "输入用户名",
            trigger: "blur"
          }
        ],
        password: [
          {
            type: "string",
            required: true,
            message: "输入密码",
            trigger: "blur"
          }
        ],
        email: [
          { required: true, message: "输入邮箱", trigger: "blur" },
          { type: "email", message: "输入正确的邮箱格式", trigger: "blur" }
        ]
      },
      /*表数据*/
      data1: [],
      /*表显示字段*/
      columns2: [
        {
          type: "selection",
          width: 60,
          align: "center"
        },
        {
          title: "角色名称",
          width: 120,
          key: "name"
        },
        {
          title: "描述",
          key: "describe"
        }
      ],
      /*表数据*/
      data2: [],
      userIdForUpdateRole: null,
      /*data2的临时存储*/
      // data2Temp: [],
      /*用户与角色关系列表*/
      relationList: null
    };
  },
  mounted() {
    /*页面初始化调用方法*/
    this.getTable({
      pageInfo: this.pageInfo,
      name: this.name
    });
    this.axios({
      method: "get",
      url: "/roles/all"
    })
      .then(
        function(response) {
          this.data2 = response.data.data;
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
  },
  methods: {
    /*pageInfo实体初始化*/
    initPageInfo() {
      this.pageInfo.page = 0;
      this.pageInfo.pageSize = 10;
    },
    /*user实体初始化*/
    initUser() {
      this.user.id = null;
      this.user.name = null;
      this.user.loginName = null;
      this.user.password = null;
      this.user.email = null;
    },
    /*userNew实体初始化*/
    initUserNew() {
      this.userNew.id = null;
      this.userNew.name = null;
      this.userNew.loginName = null;
      this.userNew.password = null;
      this.userNew.passwordAgain = null;
      this.userNew.email = null;
    },
    /*userModify实体初始化*/
    initUserModify() {
      this.userModify.id = null;
      this.userModify.name = null;
      this.userModify.loginName = null;
      this.userModify.password = null;
      this.userModify.email = null;
    },
    /*userNew设置*/
    userSet(e) {
      this.user.id = e.id;
      this.user.name = e.name;
      this.user.loginName = e.loginName;
      this.user.password = e.password;
      this.user.email = e.email;
    },
    /*userNew设置*/
    userNewSet(e) {
      this.userNew.id = e.id;
      this.userNew.name = e.name;
      this.userNew.loginName = e.loginName;
      this.userNew.password = e.password;
      this.userNew.passwordAgain = e.password;
      this.userNew.email = e.email;
    },
    /*userModify设置*/
    userModifySet(e) {
      this.userModify.id = e.id;
      this.userModify.name = e.name;
      this.userModify.usertype = e.usertype;
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
        e[i].createTime = this.dateGet(e[i].createTime);
      }
    },
    /*得到表数据*/
    getTable(e) {
      this.axios({
        method: "get",
        url: "/users",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          name: e.name
        }
      })
        .then(
          function(response) {
            this.data1 = response.data.data.data;
            this.listDateSet(this.data1);
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          console.log(error);
        });
    },
    /*搜索按钮点击事件*/
    search() {
      this.initPageInfo();
      this.getTable({
        pageInfo: this.pageInfo,
        name: this.name
      });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo,
        name: this.name
      });
    },
    /*新建点击触发事件*/
    openNewModal() {
      this.newModal = true;
      this.initUserNew();
      this.data1.sort();
      this.count = 0;
      this.groupId = null;
    },
    /*新建modal的newOk点击事件*/
    newOk(userNew) {
      this.$refs[userNew].validate(valid => {
        if (valid) {
          if (this.userNew.password == this.userNew.passwordAgain) {
            this.initUser();
            this.userSet(this.userNew);
            this.axios({
              method: "post",
              url: "/users/user",
              data: this.user
            })
              .then(
                function(response) {
                  this.initUserNew();
                  this.getTable({
                    pageInfo: this.pageInfo,
                    name: this.name
                  });
                  this.$message.info("新建成功");
                }.bind(this)
              )
              .catch(function(error) {
                alert(error);
              });
            this.newModal = false;
          } else {
            this.$message.error("两次输入的密码不相同！");
            this.loading = false;
            this.$nextTick(() => {
              this.loading = true;
            });
          }
        } else {
          this.$message.error("表单验证失败!");
          setTimeout(() => {
            this.loading = false;
            this.$nextTick(() => {
              this.loading = true;
            });
          }, 1000);
        }
      });
    },
    /*点击修改时判断是否只选择一个*/
    openModifyModal() {
      if (this.count > 1 || this.count < 1) {
        this.modifyModal = false;
        this.$message.warning("请至少选择一项(且只能选择一项)");
      } else {
        this.modifyModal = true;
      }
    },
    /*修改modal的modifyOk点击事件*/
    modifyOk() {
      // this.initUser();
      // this.userSet(this.userModify);
      this.axios({
        method: "put",
        url: "/users/user",
        data: {
          name: this.userModify.name,
          usertype: this.userModify.usertype,
          id: this.userModify.id
        }
      })
        .then(
          function(response) {
            this.initUserNew();
            this.getTable({
              pageInfo: this.pageInfo,
              name: this.name
            });
            this.$message.info("修改成功");
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
      this.modifyModal = false;
    },
    /*modal的cancel点击事件*/
    cancel() {
      this.$message.info("点击了取消");
    },
    /*table选择后触发事件*/
    change(e) {
      if (e.length == 1) {
        this.userModifySet(e["0"]);
      }
      this.setGroupId(e);
    },
    /*通过选中的行设置groupId的值*/
    setGroupId(e) {
      this.groupId = [];
      this.count = e.length;
      for (var i = 0; i <= e.length - 1; i++) {
        this.groupId.push(e[i].id);
      }
    },
    /*删除table中选中的数据*/
    del() {
      if (this.groupId != null && this.groupId != "") {
        this.axios({
          method: "delete",
          url: "/users",
          data: this.groupId
        })
          .then(
            function(response) {
              this.getTable({
                pageInfo: this.pageInfo,
                name: this.name
              });
              this.groupId = null;
              this.count = 0;
              this.$message.info("删除成功");
            }.bind(this)
          )
          .catch(function(error) {
            alert(error);
          });
      }
    },
    /*表格中双击事件*/
    dblclick(e) {
      this.userModifySet(e);
      this.modifyModal = true;
      this.data1.sort();
    },
    /*流程配置*/
    relationSet(val) {

      this.roleModal = true;
      this.userIdForUpdateRole = val.id;
      // this.data2 = [];
      
      this.axios({
        method: "get",
        url: "/relations/" + val.id
      })
        .then(
          function(response) {
            this.$refs.roleTable.clearSelection();
            response.data.data.forEach(e => {
              this.data2.forEach(row => {
                if(e.roleId == row.id) {
                  this.$refs.roleTable.toggleRowSelection(row,true);
                }
              });
            });
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    /*配置角色modal确认按钮点击事件*/
    roleOk() {
      if (this.relationList != null) {
        this.axios({
          method: "post",
          url: "/relations",
          data: this.relationList
        })
          .then(
            function(response) {
              this.roleModal = false;
              this.$message.info("配置成功");
            }.bind(this)
          )
          .catch(function(error) {
            alert(error);
          });
        this.relationList = null;
      }
    },
    /*配置角色modal中表选择改变事件*/
    change2(e) {
      this.relationList = [];
      if (e.length == 0) {
        this.relationList.push({
          userId: this.userIdForUpdateRole
        });
      }
      for (var i in e) {
        this.relationList.push({
          userId: this.userIdForUpdateRole,
          roleId: e[i].id
        });
      }
    }
  }
};
</script>
<style lang="scss" scoped>
.user-layout {
  background-color: #fff;
  padding: 20px;

  .search-block {

    .search-input {
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