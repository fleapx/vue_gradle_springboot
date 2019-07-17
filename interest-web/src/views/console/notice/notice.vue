<template>
  <div class="notice-layout">

    <div class="publish-block">
      <el-form ref="notice" :model="notice" label-width="90px" label-position="top">
        <el-form-item 
          prop="form"
          label="公告类型:" 
          :rules="{
            required: true, message: '请选择', trigger: 'change'
          }">
          <el-select class="select" v-model="notice.form" placeholder="请选择">
            <el-option
              v-for="item in noticeFormOptions"
              :key="item.value"
              :label="item.label"
              :value="item.value">
            </el-option>
          </el-select>
        </el-form-item>
        <el-form-item 
          prop="image"
          v-if="notice.form == '1'" 
          label="图片:"
          :rules="{
            required: true, message: '请上传图片', trigger: 'blur'
          }">
          <el-upload
            ref="upload"
            :headers="headers"
            name="picture"
            action="/interest/admin/interest/upload/picture"
            list-type="picture-card"
            :on-preview="handlePictureCardPreview"
            :on-remove="handleRemove"
            :on-success="handleSuccess"
            :before-upload="handleBeforeUpload"
            :on-error="handleError"
            :limit="1"
            :on-exceed="handExceed">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>
        <el-form-item 
          prop="content"
          label="内容:"
          :rules="{
            required: true, message: '请填写内容', trigger: 'blur'
          }">
          <el-input class="input" v-model="notice.content" type="textarea" :autosize="{minRows: 4,maxRows: 5}"/>
        </el-form-item>
        <el-form-item label="链接:">
          <el-input class="input" v-model="notice.url"/>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="publishNotice('notice')">发布</el-button>
        </el-form-item>
      </el-form>
    </div>

    <el-divider></el-divider>

    <div class="action-block">
      <el-radio-group v-model="formName" @change="handleRadioChange">
        <el-radio-button label="全部"></el-radio-button>
        <el-radio-button label="普通"></el-radio-button>
        <el-radio-button label="图文"></el-radio-button>
      </el-radio-group>
    </div>

    <el-table class="table-block" :data="data" border @row-dblclick="dblclick">
      <el-table-column label="公告类型" width="100">
        <template slot-scope="scope">
          <span v-if="scope.row.form == 0">普通公告</span>
          <span v-if="scope.row.form == 1">图文公告</span>
        </template>
      </el-table-column>
      <el-table-column label="图片" width="100">
        <template slot-scope="scope">
          <img v-if="scope.row.form == 1" :src="scope.row.image" width="100%">
        </template>
      </el-table-column>
      <el-table-column prop="content" label="内容"></el-table-column>
      <el-table-column label="链接">
        <template slot-scope="scope">
          <a :href="scope.row.url" target="_blank">
            {{scope.row.url}}
          </a>
        </template>
      </el-table-column>
      <el-table-column label="时间">
        <template slot-scope="scope">
          <span>{{dateGet(scope.row.updateTime)}}</span>
        </template>
      </el-table-column>
      <el-table-column label="操作" align="center" width="100">
        <template slot-scope="scope">
          <el-button type="primary" icon="el-icon-edit" circle size="small" @click="handleClickEdit(scope.row)"></el-button>
          <el-button type="danger" icon="el-icon-delete" circle size="small" @click="delNotice(scope.row)"></el-button>
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
    <el-dialog title="查看" :visible.sync="updateDialog" width="600px" :close-on-click-modal="false">
      <el-form ref="noticeUpdateModel" :model="noticeUpdateModel" label-width="90px" label-position="top">
        <el-form-item 
          prop="image"
          v-if="noticeUpdateModel.form == '1'" 
          label="图片:"
          :rules="{
            required: true, message: '请上传图片', trigger: 'blur'
          }">
          <el-upload
            :file-list="updateFileList"
            ref="upload"
            :headers="headers"
            name="picture"
            action="/interest/admin/interest/upload/picture"
            list-type="picture-card"
            :on-preview="handlePictureCardPreview"
            :on-remove="handleRemove"
            :on-success="handleUpdateSuccess"
            :before-upload="handleBeforeUpload"
            :on-error="handleError"
            :limit="1"
            :on-exceed="handExceed">
            <i class="el-icon-plus"></i>
          </el-upload>
        </el-form-item>
        <el-form-item 
          prop="content"
          label="内容:"
          :rules="{
            required: true, message: '请填写内容', trigger: 'blur'
          }">
          <el-input v-model="noticeUpdateModel.content" type="textarea" :autosize="{minRows: 4,maxRows: 5}"/>
        </el-form-item>
        <el-form-item label="链接:">
          <el-input v-model="noticeUpdateModel.url"/>
        </el-form-item>
      </el-form>
      <span slot="footer">
        <el-button type="primary" @click="updateNotice('noticeUpdateModel')">保 存</el-button>
        <el-button @click="updateDialog = false">关 闭</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
export default {
  data() {
    return {
      updateFileList: [],
      formName: '全部',
      form: null,
      del: 0,
      headers: {
        Authorization: "bearer " + localStorage.getItem("currentUser_token")
      },
      noticeFormOptions: [{
        value: '0',
        label: '普通公告'
      },{
        value: '1',
        label: '图文公告'
      }],
      /*修改modal的显示参数*/
      updateDialog: false,
      /*分页total属性绑定值*/
      total: 0,
      /*pageInfo实体*/
      pageInfo: {
        page: 0,
        pageSize: 10
      },
      notice: {
        form: null,
        image: null,
        content: null,
        url: null
      },
      noticeUpdateModel: {
        id: null,
        form: null,
        image: null,
        content: null,
        url: null
      },
      /*表数据*/
      data: []
    };
  },
  created() {
    /*页面初始化调用方法*/
    this.search();
  },
  methods: {
    handleRadioChange(val){
      if(val == '全部'){
        this.form = null;
      }else if(val == '普通'){
        this.form = 0;
      }else if(val == '图文'){
        this.form = 1;
      }
      this.search();
    },
    delNotice(val){
      this.axios({
        method: "delete",
        url: "/notices/notice/" + val.id,
      })
        .then(
          function(response) {
            this.search();
            this.$message.success("删除成功");
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    updateNotice(val){
      this.$refs[val].validate((valid) => {
        if (valid) {
          this.axios({
            method: "put",
            url: "/notices/notice",
            data: this.noticeUpdateModel
          })
            .then(
              function(response) {
                this.search();
                this.updateDialog = false;
                this.$message.success("修改成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
        } else {
          return false;
        }
      });
    },
    handleClickEdit(val){
      this.noticeUpdateModel.id = val.id;
      this.noticeUpdateModel.form = val.form;
      this.noticeUpdateModel.image = val.image;
      this.noticeUpdateModel.content = val.content;
      this.noticeUpdateModel.url = val.url;
      this.updateDialog = true;
      this.updateFileList = [{
        name: 'picture',
        url: this.noticeUpdateModel.image
      }];
    },
    initNotice(){
      this.notice.form = null;
      this.notice.image = null;
      this.notice.content = null;
      this.notice.url = null;
    },
    publishNotice(val){
      this.$refs[val].validate((valid) => {
        if (valid) {
          this.axios({
            method: "post",
            url: "/notices/notice",
            data: this.notice
          })
            .then(
              function(response) {
                this.search();
                this.initNotice();
                this.$message.success("发布成功");
              }.bind(this)
            )
            .catch(function(error) {
              alert(error);
            });
        } else {
          return false;
        }
      });
    },
    handleSelectChnage(val){
      this.notice.image = null;
      this.$refs.upload.clearFiles();
    },
    handExceed(){
      this.$message.warning("超过上传数量");
    },
    handleError () {
      this.$message.error("图片上传失败");
    },
    handleBeforeUpload (file) {
      let formatVerify = file.type === 'image/jpeg' || file.type === 'image/png';
      let sizeVerify = file.size < 1024 * 1024;

      if (!formatVerify) {
        this.$notify.warning({
            title: '图片格式不对',
            message: '图片格式只能为jpeg,png'
        });
      }
      if (!sizeVerify) {
        this.$notify.warning({
            title: '图片太大',
            message: '上传图片最大为1M,请优化后在上传。可使用https://zhitu.isux.us/网站优化'
        });
      }
      return formatVerify && sizeVerify;
    },
    handleRemove(file, fileList) {
      this.$refs.upload.clearFiles();
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url;
      this.dialogVisible = true;
    },
    handleUpdateSuccess(res, file) {
      this.noticeUpdateModel.image = res.data.url;
    },
    handleSuccess(res, file) {
      this.notice.image = res.data.url;
    },
    /*pageInfo实体初始化*/
    initPageInfo() {
      this.pageInfo.page = 0;
      this.pageInfo.pageSize = 10;
    },
    /*得到表数据*/
    getTable(e) {
      this.axios({
        method: "get",
        url: "/notices",
        params: {
          pageIndex: e.pageInfo.page,
          pageSize: e.pageInfo.pageSize,
          del: e.del,
          form: e.form
        }
      })
        .then(
          function(response) {
            this.data = response.data.data.data;
            this.total = response.data.data.totalCount;
          }.bind(this)
        )
        .catch(function(error) {
          alert(error);
        });
    },
    search() {
      this.getTable({
        pageInfo: this.pageInfo,
        del: this.del,
        form: this.form
      });
    },
    /*分页点击事件*/
    pageSearch(e) {
      this.pageInfo.page = e - 1;
      this.getTable({
        pageInfo: this.pageInfo,
        del: this.del
      });
    },
    /*表格中双击事件*/
    dblclick(val) {
      this.handleClickEdit(val)
    },
  }
};
</script>
<style lang="scss">
.notice-layout {
  .el-upload-list__item {
    height: auto;
    width: 300px;

    img {
      display: block;
      height: auto;
    }
  }
}
</style>
<style lang="scss" scoped>
.notice-layout {
  background-color: #fff;
  padding: 20px;

  .publish-block {

    .select {
      width: 200px;
    }
    .input {
      width: 50%;
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