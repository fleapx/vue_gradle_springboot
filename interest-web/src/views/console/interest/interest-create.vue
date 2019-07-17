<template>
  <div class="interest-layout">
    <el-form ref="entity" :model="entity" :rules="ruleNew" label-width="80px" label-position="top">
      <el-form-item label="标题：" prop="title">
          <el-input class="title" v-model="entity.title"/>
      </el-form-item>
      <el-form-item label="简介：" prop="info">
          <el-input class="info" v-model="entity.info" type="textarea" :autosize="{minRows: 4,maxRows: 5}"/>
      </el-form-item>
      <el-form-item label="图片：" prop="image">
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
      <el-form-item label="详情：" prop="content">
        <i-quill-editor class="editor" v-model="entity.content"></i-quill-editor>
      </el-form-item>
      <el-form-item>
          <el-button type="primary" @click="submit('entity')" size="small">提交</el-button>
          <el-button @click="reset" size="small">重置</el-button>
      </el-form-item>
    </el-form>
    <el-dialog :visible.sync="dialogVisible">
      <img width="100%" :src="dialogImageUrl" alt="">
    </el-dialog>
  </div>
</template>
<script>
import iQuillEditor from "@components/i-quill-editor.vue";
export default {
  components: {
    "i-quill-editor": iQuillEditor
  },
  data() {
    return {
      dialogImageUrl: '',
      dialogVisible: false,
      headers: {
        Authorization: "bearer " + localStorage.getItem("currentUser_token")
      },
      /*entity实体*/
      entity: {
        title: null,
        info: null,
        image: null,
        content: null
      },
      /*新建验证*/
      ruleNew: {
        title: [
          {
            type: "string",
            required: true,
            message: "填写标题",
            trigger: "blur"
          }
        ],
        info: [
          {
            type: "string",
            required: true,
            message: "填写介绍",
            trigger: "blur"
          }
        ],
        image: [
          {
            type: "string",
            required: true,
            message: "上传图片",
            trigger: "blur"
          }
        ],
        content: [
          {
            type: "string",
            required: true,
            message: "填写内容",
            trigger: "blur"
          }
        ]
      }
    };
  },
  methods: {
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
    handleSuccess(res, file) {
      this.entity.image = res.data.url;
    },
    /*entity实体初始化*/
    initEntity() {
      this.entity.title = null;
      this.entity.info = null;
      this.entity.image = null;
      this.entity.content = null;
    },
    submit(entity) {
      this.$refs[entity].validate(valid => {
        if (valid) {
          this.axios({
            method: "post",
            url: "/admin/interests/interest",
            data: this.entity
          })
            .then(
              function(response) {
                this.initEntity();
                this.$message.info("新建成功");
                this.$refs.upload.clearFiles();
              }.bind(this)
            )
            .catch(
              function(error) {
                this.$message.error("新建失败");
              }.bind(this)
            );
        }
      });
    },
    reset() {
      this.$refs.upload.clearFiles();
      this.initEntity();
    }
  }
};
</script>
<style lang="scss">
.interest-layout {
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
.interest-layout {
  background-color: #fff;
  padding: 20px;

  .title {
    width: 204px;
  }
  .info {
    width: 50%;
  }
}
</style>
<style lang="scss">
.editor {
  .ql-container {
    .ql-editor{
        min-height: 30rem;
      }
  } 
}
</style>