<template>
  <div class="role-layout">

    <div class="action-block">
      <el-button type="primary" icon="el-icon-plus" size="small" @click="openNewModal">新建</el-button>
      <el-button type="success" icon="el-icon-edit" size="small" @click="openModifyModal">修改</el-button>
      <el-button type="danger" icon="el-icon-delete" size="small" @click="del">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change" @row-dblclick="dblclick" height="336px">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="role" label="角色"></el-table-column>
      <el-table-column prop="name" label="角色名"></el-table-column>
      <el-table-column prop="describe" label="描述"></el-table-column>
      <el-table-column label="配置" width="180" align="center">
        <template slot-scope="scope">
          <el-button type="primary" icon="el-icon-setting" circle @click="setting(scope.row)" size="small"></el-button>
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

    <!--添加modal-->  
    <el-dialog
      title="新建"
      :visible.sync="newModal"
      width="600px"
      :close-on-click-modal="false">
      <span>
        <el-form ref="roleNew" :model="roleNew" :rules="ruleNew" label-width="80px" size="small">
          <el-row :gutter="24">
              <el-col :span="12">
                <el-form-item label="角色:" prop="role">
                    <el-input v-model="roleNew.role"/>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                   <el-form-item label="角色名:" prop="name">
                      <el-input v-model="roleNew.name"/>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-form-item label="描述:" prop="describe">
               <el-input v-model="roleNew.describe" type="textarea" :autosize="{minRows: 2,maxRows: 5}"></el-input>
          </el-form-item>
        </el-form>
      </span>
      <span slot="footer">
        <el-button @click="newModal = false">取 消</el-button>
        <el-button type="primary" @click="newOk('roleNew')">确 定</el-button>
      </span>
    </el-dialog>
    <!--修改modal-->  
    <el-dialog
      title="修改"
      :visible.sync="modifyModal"
      width="600px"
      :close-on-click-modal="false">
      <span>
        <el-form ref="roleModify" :model="roleModify" :rules="ruleModify" label-width="80px" size="small">
          <el-row :gutter="24">
              <el-col :span="12">
                <el-form-item label="角色:" prop="role">
                    <el-input v-model="roleModify.role"/>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                   <el-form-item label="角色名:" prop="name">
                      <el-input v-model="roleModify.name"/>
                  </el-form-item>
              </el-col>
          </el-row>
          <el-form-item label="描述:" prop="describe">
               <el-input v-model="roleModify.describe" type="textarea" :autosize="{minRows: 2,maxRows: 5}"></el-input>
          </el-form-item>
        </el-form>
      </span>
      <span slot="footer">
        <el-button @click="modifyModal = false">取 消</el-button>
        <el-button type="primary" @click="modifyOk('roleModify')">确 定</el-button>
      </span>
    </el-dialog>
    <!-- 配置权限 -->
    <el-dialog
      title="配置权限"
      :visible.sync="settingModal"
      width="400px"
      :close-on-click-modal="false">
      <span>
        <el-table :data="data2" border>
          <el-table-column prop="name" label="权限"></el-table-column>
          <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <el-switch
                v-model="scope.row.value"
                @change="e => {switchChange(e,scope.row)}">
              </el-switch>
            </template>
          </el-table-column>
        </el-table>
      </span>
      <span slot="footer">
        <el-button @click="settingModal = false">取 消</el-button>
        <el-button type="primary" @click="settingOk">确 定</el-button>
      </span>
    </el-dialog>
    <!-- <Modal v-model="settingModal"  width="400" title="配置权限" @on-ok="settingOk()" @on-cancel="cancel()" :mask-closable="false">

        <Row>
            <Col span="24"><Table border :columns="columns2" :data="data2"></Table></Col>
        </Row>
    </Modal> -->
  </div>
</template>
<script>
export default {
  data() {
    return {
      /*选择的数量*/
      count: null,
      /*选中的组数据*/
      groupId: null,
      /*新建modal的显示参数*/
      newModal: false,
      /*修改modal的显示参数*/
      modifyModal: false,
      /*权限modal的显示参数*/
      settingModal: false,
      /*分页total属性绑定值*/
      total: 0,
      /*loading*/
      loading: true,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      /*role实体*/
      role: {
        id: null,
        role: null,
        name: null,
        modules: null,
        describe: null
      },
      /*用于添加的role实体*/
      roleNew: {
        id: null,
        role: null,
        name: null,
        modules: null,
        describe: null
      },
      /*用于修改的role实体*/
      roleModify: {
        id: null,
        role: null,
        name: null,
        modules: null,
        describe: null
      },
      /*新建验证*/
      ruleNew: {
        role: [
          {
            type: "string",
            required: true,
            message: "输入角色",
            trigger: "blur"
          }
        ],
        name: [
          {
            type: "string",
            required: true,
            message: "输入角色名",
            trigger: "blur"
          }
        ]
      },
      /*修改验证*/
      ruleModify: {
        role: [
          {
            type: "string",
            required: true,
            message: "输入角色",
            trigger: "blur"
          }
        ],
        name: [
          {
            type: "string",
            required: true,
            message: "输入角色名",
            trigger: "blur"
          }
        ]
      },
      /*表数据*/
      data1: [],
      /*表数据*/
      data2: [],
      /*临时存储权限的数组*/
      moduleArr: [],
      /*二级菜单列表*/
      submenusList: []
    };
  },
  mounted() {
    /*页面初始化调用方法*/
    this.getTable({
      pageInfo: this.pageInfo
    });
    this.axios({
      method: "get",
      url: "/menus/submenus"
    })
      .then(
        function(response) {
          this.submenusList = response.data.data;
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
  },
  methods: {
    switchChange(val,row){
      let i = this.moduleArr.indexOf(row.id + "");
      if (val) {
        if (i == -1) {
          this.moduleArr.push(row.id + "");
        }
      } else {
        if (i != -1) {
          this.moduleArr.splice(i, 1);
        }
      }
    },
    /*pageInfo实体初始化*/
    initPageInfo() {
      this.pageInfo.page = 0;
      this.pageInfo.pageSize = 10;
    },
    /*role实体初始化*/
    initRole() {
      this.role.id = null;
      this.role.role = null;
      this.role.name = null;
      this.role.modules = null;
      this.role.describe = null;
    },
    /*roleNew实体初始化*/
    initRoleNew() {
      this.roleNew.id = null;
      this.roleNew.role = null;
      this.roleNew.name = null;
      this.roleNew.modules = null;
      this.roleNew.describe = null;
    },
    /*roleModify实体初始化*/
    initRoleModify() {
      this.roleModify.id = null;
      this.roleModify.role = null;
      this.roleModify.name = null;
      this.roleModify.modules = null;
      this.roleModify.describe = null;
    },
    /*roleNew设置*/
    roleSet(e) {
      this.role.id = e.id;
      this.role.role = e.role;
      this.role.name = e.name;
      this.role.modules = e.modules;
      this.role.describe = e.describe;
    },
    /*roleNew设置*/
    roleNewSet(e) {
      this.roleNew.id = e.id;
      this.roleNew.role = e.role;
      this.roleNew.name = e.name;
      this.roleNew.modules = e.modules;
      this.roleNew.describe = e.describe;
    },
    /*roleModify设置*/
    roleModifySet(e) {
      this.roleModify.id = e.id;
      this.roleModify.role = e.role;
      this.roleModify.name = e.name;
      this.roleModify.modules = e.modules;
      this.roleModify.describe = e.describe;
    },
    /*得到表数据*/
    getTable(e) {
      this.axios({
        method: "get",
        url: "/roles",
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
    /*新建点击触发事件*/
    openNewModal() {
      this.newModal = true;
      this.initRoleNew();
      this.data1.sort();
      this.count = 0;
      this.groupId = null;
    },
    /*新建modal的newOk点击事件*/
    newOk(roleNew) {
      this.$refs[roleNew].validate(valid => {
        if (valid) {
          this.initRole();
          this.roleSet(this.roleNew);
          this.axios({
            method: "post",
            url: "/roles/role",
            data: this.role
          })
            .then(
              function(response) {
                this.initRoleNew();
                this.getTable({
                  pageInfo: this.pageInfo
                });
                this.$message.info("新建成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
          this.newModal = false;
        } else {
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
    modifyOk(roleModify) {
      this.$refs[roleModify].validate(valid => {
        if (valid) {
          this.initRole();
          this.roleSet(this.roleModify);
          this.axios({
            method: "put",
            url: "/roles/" + this.role.id,
            data: this.role
          })
            .then(
              function(response) {
                this.initRoleModify();
                this.getTable({
                  pageInfo: this.pageInfo
                });
                this.$message.info("修改成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
          this.modifyModal = false;
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
    /*表格中按钮点击事件*/
    setting(e) {
      this.data1.sort();
      this.settingModal = true;
      this.roleModifySet(e);
      if (e.modules == null || e.modules == "") {
        this.moduleArr = [];
      } else {
        this.moduleArr = e.modules.split(";");
      }
      var data2Temp = [];
      for (var i = 0; i < this.submenusList.length; i++) {
        if (this.moduleArr.indexOf(this.submenusList[i].id + "") == -1) {
          data2Temp.push({
            id: this.submenusList[i].id,
            name: this.submenusList[i].name,
            value: false
          });
        } else {
          data2Temp.push({
            id: this.submenusList[i].id,
            name: this.submenusList[i].name,
            value: true
          });
        }
      }
      this.data2 = data2Temp;
    },
    /*配置权限的settingOk点击事件*/
    settingOk() {
      var temp = "";
      for (var i in this.moduleArr) {
        if (this.moduleArr[i] != "" && this.moduleArr != null) {
          temp = temp + this.moduleArr[i] + ";";
        }
      }
      this.roleModify.modules = temp;
      this.initRole();
      this.roleSet(this.roleModify);
      this.axios({
        method: "put",
        url: "/roles/" + this.role.id,
        data: this.role
      })
        .then(
          function(response) {
            this.settingModal = false;
            this.initRoleModify();
            this.getTable({
              pageInfo: this.pageInfo
            });
            this.$message.info("配置成功");
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    /*modal的cancel点击事件*/
    cancel() {
      this.$message.info("点击了取消");
    },
    /*table选择后触发事件*/
    change(e) {
      if (e.length == 1) {
        this.roleModifySet(e["0"]);
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
          url: "/roles",
          data: this.groupId
        })
          .then(
            function(response) {
              this.getTable({
                pageInfo: this.pageInfo
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
      this.roleModifySet(e);
      this.modifyModal = true;
      this.data1.sort();
    }
  }
};
</script>
<style lang="scss" scoped>
.role-layout {
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