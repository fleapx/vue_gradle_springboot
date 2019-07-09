<template>
  <div class="menu-layout">

    <div class="search-block">
      <el-row :gutter="24">
        <el-col :span="8">
          菜单名称：
          <el-select class="search-select" v-model="menuId" placeholder="请选择" clearable size="small">
            <el-option v-for="item in menuList" :key="item.value" :label="item.label" :value="item.value"></el-option>
          </el-select>
        </el-col>
        <el-col :span="8">
          <el-button type="primary" icon="el-icon-search" round size="small" @click="search">搜索</el-button>
        </el-col>
      </el-row>
    </div>

    <div class="action-block">
      <el-button type="primary" icon="el-icon-plus" size="small" @click="openNewModal">新建</el-button>
      <el-button type="success" icon="el-icon-edit" size="small" @click="openModifyModal">修改</el-button>
      <el-button type="danger" icon="el-icon-delete" size="small" @click="del">删除</el-button>
    </div>

    <el-table class="table-block" :data="data1" border @selection-change="change" @row-dblclick="dblclick">
      <el-table-column type="selection" width="55" align="center"></el-table-column>
      <el-table-column prop="id" label="菜单ID"></el-table-column>
      <el-table-column prop="name" label="菜单名称"></el-table-column>
      <el-table-column prop="url" label="地址"></el-table-column>
      <el-table-column prop="parentId" label="上级菜单id"></el-table-column>
      <el-table-column prop="sort" label="排序"></el-table-column>
      <el-table-column prop="icon" label="图标"></el-table-column>
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
        <el-form :model="menuNew" :rules="ruleNew" ref="menuNew" label-width="90px" size="small">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="菜单名称:" prop="name">
                <el-input v-model="menuNew.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="路径:" prop="url">
                  <el-input v-model="menuNew.url"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="父类ID:" prop="parentId">
                <el-input v-model="menuNew.parentId"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="排序号:" prop="sort">
                  <el-input v-model="menuNew.sort"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="图标:" prop="icon">
                <el-input v-model="menuNew.icon"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="描述:" prop="remark">
                  <el-input v-model="menuNew.remark" type="textarea" :autosize="{minRows: 2,maxRows: 5}"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </span>
      <span slot="footer">
        <el-button @click="newModal = false">取 消</el-button>
        <el-button type="primary" @click="newOk('menuNew')">确 定</el-button>
      </span>
    </el-dialog>
    <!--修改modal-->
    <el-dialog title="修改" :visible.sync="modifyModal" width="600px" :close-on-click-modal="false">
      <span>
        <el-form :model="menuModify" :rules="ruleModify" ref="menuModify" label-width="90px" size="small">
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="菜单名称:" prop="name">
                <el-input v-model="menuModify.name"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="路径:" prop="url">
                  <el-input v-model="menuModify.url"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="父类ID:" prop="parentId">
                <el-input v-model="menuModify.parentId"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="排序号:" prop="sort">
                  <el-input v-model="menuModify.sort"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24">
            <el-col :span="12">
              <el-form-item label="图标:" prop="icon">
                <el-input v-model="menuModify.icon"></el-input>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="描述:" prop="remark">
                  <el-input v-model="menuModify.remark" type="textarea" :autosize="{minRows: 2,maxRows: 5}"></el-input>
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </span>
      <span slot="footer">
        <el-button @click="modifyModal = false">取 消</el-button>
        <el-button type="primary" @click="modifyOk('menuModify')">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
export default {
  data() {
    return {
      /*用于查找的菜单id*/
      menuId: null,
      /*选择的数量*/
      count: null,
      /*选中的组数据*/
      groupId: null,
      /*新建modal的显示参数*/
      newModal: false,
      /*修改modal的显示参数*/
      modifyModal: false,
      /*分页total属性绑定值*/
      total: 0,
      /*loading*/
      loading: true,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      /*menu实体*/
      menu: {
        id: null,
        name: null,
        url: null,
        parentId: null,
        sort: null,
        remark: null,
        icon: null
      },
      /*用于添加的menu实体*/
      menuNew: {
        id: null,
        name: null,
        url: null,
        parentId: null,
        sort: null,
        remark: null,
        icon: null
      },
      /*用于修改的menu实体*/
      menuModify: {
        id: null,
        name: null,
        url: null,
        parentId: null,
        sort: null,
        remark: null,
        icon: null
      },
      /*新建验证*/
      ruleNew: {
        name: [
          {
            type: "string",
            required: true,
            message: "输入菜单名",
            trigger: "blur"
          }
        ],
        url: [
          {
            type: "string",
            required: true,
            message: "输入路径",
            trigger: "blur"
          }
        ],
        parentId: [
          { required: true, message: "输入父类ID", trigger: "blur" },
          {
            validator(rule, value, callback) {
              if (!Number.isInteger(+value)) {
                callback(new Error("请输入数字"));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ],
        sort: [
          { required: true, message: "输入排序", trigger: "blur" },
          {
            validator(rule, value, callback) {
              if (!Number.isInteger(+value)) {
                callback(new Error("请输入数字"));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ],
        icon: [
          {
            type: "string",
            required: true,
            message: "输入图标",
            trigger: "blur"
          }
        ]
      },
      /*修改验证*/
      ruleModify: {
        name: [
          {
            type: "string",
            required: true,
            message: "输入菜单名",
            trigger: "blur"
          }
        ],
        url: [
          {
            type: "string",
            required: true,
            message: "输入路径",
            trigger: "blur"
          }
        ],
        parentId: [
          { required: true, message: "输入父类ID", trigger: "blur" },
          {
            validator(rule, value, callback) {
              if (!Number.isInteger(+value)) {
                callback(new Error("请输入数字"));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ],
        sort: [
          { required: true, message: "输入排序", trigger: "blur" },
          {
            validator(rule, value, callback) {
              if (!Number.isInteger(+value)) {
                callback(new Error("请输入数字"));
              } else {
                callback();
              }
            },
            trigger: "blur"
          }
        ],
        icon: [
          {
            type: "string",
            required: true,
            message: "输入图标",
            trigger: "blur"
          }
        ]
      },
      /*菜单列表*/
      menuList: [],
      /*生产类型表数据*/
      data1: []
    };
  },
  mounted() {
    /*页面初始化调用方法*/
    this.getTable({
      pageInfo: this.pageInfo,
      menuId: this.menuId
    });
    this.axios({
      method: "get",
      url: "/menus/parentId",
      params: {
        parentId: 0
      }
    })
      .then(
        function(response) {
          var listTemp = response.data.data;
          for (var i = 0; i < listTemp.length; i++) {
            this.menuList.push({
              value: listTemp[i].id,
              label: listTemp[i].name
            });
          }
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
    /*menu实体初始化*/
    initMenu() {
      this.menu.id = null;
      this.menu.name = null;
      this.menu.url = null;
      this.menu.parentId = null;
      this.menu.sort = null;
      this.menu.remark = null;
      this.menu.icon = null;
    },
    /*menuNew实体初始化*/
    initMenuNew() {
      this.menuNew.id = null;
      this.menuNew.name = null;
      this.menuNew.url = null;
      this.menuNew.parentId = null;
      this.menuNew.sort = null;
      this.menuNew.remark = null;
      this.menuNew.icon = null;
    },
    /*menuModify实体初始化*/
    initMenuModify() {
      this.menuModify.id = null;
      this.menuModify.name = null;
      this.menuModify.url = null;
      this.menuModify.parentId = null;
      this.menuModify.sort = null;
      this.menuModify.remark = null;
      this.menuModify.icon = null;
    },
    /*menuNew设置*/
    menuSet(e) {
      this.menu.id = e.id;
      this.menu.name = e.name;
      this.menu.url = e.url;
      this.menu.parentId = e.parentId;
      this.menu.sort = e.sort;
      this.menu.remark = e.remark;
      this.menu.icon = e.icon;
    },
    /*menuNew设置*/
    menuNewSet(e) {
      this.menuNew.id = e.id;
      this.menuNew.name = e.name;
      this.menuNew.url = e.url;
      this.menuNew.parentId = e.parentId;
      this.menuNew.sort = e.sort;
      this.menuNew.remark = e.remark;
      this.menuNew.icon = e.icon;
    },
    /*menuModify设置*/
    menuModifySet(e) {
      this.menuModify.id = e.id;
      this.menuModify.name = e.name;
      this.menuModify.url = e.url;
      this.menuModify.parentId = e.parentId + "";
      this.menuModify.sort = e.sort + "";
      this.menuModify.remark = e.remark;
      this.menuModify.icon = e.icon;
    },
    /*得到表数据*/
    getTable(e) {
      this.axios({
        method: "get",
        url: "/menus",
        params: {
          page: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          menuId: e.menuId
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
    /*搜索按钮点击事件*/
    search() {
      this.initPageInfo();
      this.getTable({
        pageInfo: this.pageInfo,
        menuId: this.menuId
      });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo,
        menuId: this.menuId
      });
    },
    /*新建点击触发事件*/
    openNewModal() {
      this.newModal = true;
      this.initMenuNew();
      this.data1.sort();
      this.count = 0;
      this.groupId = null;
    },
    /*新建modal的newOk点击事件*/
    newOk(menuNew) {
      this.$refs[menuNew].validate(valid => {
        if (valid) {
          this.initMenu();
          this.menuSet(this.menuNew);
          this.axios({
            method: "post",
            url: "/menus/menu",
            data: this.menu
          })
            .then(
              function(response) {
                this.initMenuNew();
                this.getTable({
                  pageInfo: this.pageInfo,
                  menuId: this.menuId
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
    modifyOk(menuModify) {
      this.$refs[menuModify].validate(valid => {
        if (valid) {
          this.initMenu();
          this.menuSet(this.menuModify);
          this.axios({
            method: "put",
            url: "/menus/" + this.menu.id,
            data: this.menu
          })
            .then(
              function(response) {
                this.initMenuNew();
                this.getTable({
                  pageInfo: this.pageInfo,
                  menuId: this.menuId
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
    /*modal的cancel点击事件*/
    cancel() {
      this.$message.info("点击了取消");
    },
    /*table选择后触发事件*/
    change(e) {
      if (e.length == 1) {
        this.menuModifySet(e["0"]);
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
          url: "/menus",
          data: this.groupId
        })
          .then(
            function(response) {
              this.getTable({
                pageInfo: this.pageInfo,
                menuId: this.menuId
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
      this.menuModifySet(e);
      this.modifyModal = true;
      this.data1.sort();
    }
  }
};
</script>
<style lang="scss" scoped>
.menu-layout {
  background-color: #fff;
  padding: 20px;

  .search-block {
    margin-bottom: 20px;

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