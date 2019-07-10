<template>
  <div class="interest-layout">
    <div class="search-block">
      兴趣：
      <el-select class="search-select" v-model="interestId" placeholder="请选择" clearable size="small" @change="selectChange">
        <el-option v-for="item in interestList" :key="item.value" :label="item.label" :value="item.value"></el-option>
      </el-select>
    </div>

    <el-divider></el-divider>

    <el-form ref="entity" :model="entity" :rules="ruleNew" :label-width="80" label-position="top">
      <el-form-item label="标题：" prop="title">
          <el-input class="title" v-model="entity.title"/>
      </el-form-item>
      <el-form-item label="排序：" prop="sort">
          <el-input v-model="entity.sort" style="width: 204px"></el-input>
      </el-form-item>
      <el-form-item label="简介：" prop="info">
          <el-input class="info" v-model="entity.info" type="textarea" :autosize="{minRows: 4,maxRows: 5}"/>
      </el-form-item>
      <el-form-item label="图片：" prop="image">
        <el-upload
          ref="upload"
          :file-list="uploadFileList"
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
          <el-button type="primary" @click="submit('entity')" size="small">修改</el-button>
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
      uploadFileList: [],
      dialogImageUrl: '',
      dialogVisible: false,
      interestId: null,
      interestList: [],
      headers: {
        Authorization: "bearer " + localStorage.getItem("currentUser_token")
      },
      /*entity实体*/
      entity: {
        id: null,
        title: null,
        info: null,
        image: null,
        content: null,
        sort: null
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
        ]
      }
    };
  },
  mounted() {
    // console.log(this.$refs.myQuillEditor);
    /*页面初始化调用方法*/
    //this.getTable();
    this.axios({
      method: "get",
      url: "/public/interests"
    })
      .then(
        function(response) {
          var listTemp = response.data.data;
          for (var i = 0; i < listTemp.length; i++) {
            this.interestList.push({
              value: listTemp[i].id,
              label: listTemp[i].title
            });
          }
        }.bind(this)
      )
      .catch(function(error) {
        alert(error);
      });
  },
  methods: {
    handExceed(){
      this.$message.warning("超过上传数量");
    },
    handleError () {
      this.$message.error("图片上传失败");
    },
    handleRemove(file, fileList) {
      this.$refs.upload.clearFiles();
    },
    handlePictureCardPreview(file) {
      this.dialogImageUrl = file.url;
      this.dialogVisible = true;
    },
    /*entity实体初始化*/
    initEntity() {
      this.entity.id = null;
      this.entity.title = null;
      this.entity.info = null;
      this.entity.image = null;
      this.entity.content = null;
      this.entity.sort = null;
    },
    /*entityNew设置*/
    entitySet(e) {
      this.entity.id = e.id;
      this.entity.title = e.title;
      this.entity.info = e.info;
      this.entity.image = e.image;
      this.entity.content = e.content;
      this.entity.sort = e.sort + "";
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
        e[i].time = this.dateGet(e[i].time);
      }
    },
    handleSuccess(res, file) {
      this.entity.image = res.data.url;
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
    handleFormatError(file) {
      this.$Notice.warning({
        title: "图片格式不对",
        desc: "图片格式只能为jpg,jpeg,png"
      });
    },
    contentGet(e) {
      this.entity.content = e;
    },
    submit(entity) {
      this.$refs[entity].validate(valid => {
        if (valid) {
          this.axios({
            method: "put",
            url: "/admin/interests/interest",
            data: this.entity
          })
            .then(
              function(response) {
                this.$message.info("修改成功");
              }.bind(this)
            )
            .catch(
              function(error) {
                this.$message.error("修改失败");
              }.bind(this)
            );
        }
      });
    },
    selectChange(e) {
      this.axios({
        method: "get",
        url: "/public/interests/interest",
        params: {
          id: e
        }
      })
        .then(
          function(response) {
            this.entitySet(response.data.data);
            this.uploadFileList = [{
              name: 'picture',
              url: this.entity.image
            }];
          }.bind(this)
        )
        .catch(
          function(error) {
            this.$message.error("请选择");
          }.bind(this)
        );
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

  .search-block {

    .search-select {
      width: 200px;
    }
  }

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