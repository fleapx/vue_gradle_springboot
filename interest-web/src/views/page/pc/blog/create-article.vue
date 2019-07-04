<template>
	<div class="create-article">
    <el-form ref="entity" :model="entity" :rules="ruleNew" :label-width="80" label-position="top">
      <el-form-item label="标题" prop="title">
          <el-input v-model="entity.title"></el-input>
      </el-form-item>
      <el-form-item label="详情" prop="content">
          <i-quill-editor class="editor" v-model="entity.content"></i-quill-editor>
      </el-form-item>
      <el-form-item>
          <el-button type="primary" @click="submit('entity')">发布</el-button>
          <el-button @click="reset()" class="reset-button">重置</el-button>
      </el-form-item>
    </el-form>

    <el-dialog
      :visible="modal"
      width="360px">
      <p slot="title" class="dialog-title">
          <Icon type="ios-information-circle"></Icon>
          <span>温馨提示</span>
      </p>
      <div class="dialog-body">
          <p>为保证服务正常运行，每个用户每日只能发布一篇文章，是否确认发布？</p>
      </div>
      <div slot="footer">
          <el-button class="publish-button" type="warning" long :loading="modal_loading" @click="publish()">确认</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<script>
import iQuillEditor from "@components/i-quill-editor";
export default {
  components: {
    "i-quill-editor": iQuillEditor
  },
  data() {
    return {
      modal:false,
      modal_loading: false,
      content: null,
      /*entity实体*/
      entity: {
        title: null,
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
  mounted() {
    /*页面初始化调用方法*/
    //this.getTable();
  },
  methods: {
    /*entity实体初始化*/
    initEntity() {
      this.entity.title = null;
      this.entity.content = null;
    },
    /*entityNew设置*/
    entitySet(e) {
      this.entity.title = e.title;
      this.entity.content = e.content;
    },
    submit(entity) {
      this.$refs[entity].validate(valid => {
        if (valid) {
          this.modal = true;
        }
      });
    },
    publish(){
      this.modal_loading =  true;
      this.axios({
        method: "post",
        url: "/article",
        data: this.entity
      }).then(
          function(response) {
            if(response.data.status == "2000"){
              this.initEntity();
              setTimeout(() => {
                  this.modal_loading = false;
                  this.modal = false;
                  this.$router.push("/article/create/success");
              }, 2000);
            }else if(response.data.status == "6001"){
              this.modal_loading = false;
              this.modal = false;
              this.$message.error(response.data.message);
            }
            
          }.bind(this)
        ).catch(
          function(error) {
            this.$Message.error("新建失败");
          }.bind(this)
        );
    },
    reset() {
      this.initEntity();
    }
  }
};
</script>
<style lang="scss">
  .editor {
    .ql-container {
      .ql-editor{
          min-height: 30rem;
        }
    } 
  }
</style>
<style type="text/css" scoped>
.create-article {
  width: 80%;
  margin: 0 auto;
  background-color: #fff;
  padding: 20px;
}
.editor {
  width: 100%;
}
.reset-button {
  margin-left: 10px;
}
.dialog-title {
  color: #e6a23c;
  text-align:center;
  line-height: 24px;
  font-size: 18px;
}
.dialog-body {
  text-align:center;
}
.publish-button {
  width: 100%;
}
</style>