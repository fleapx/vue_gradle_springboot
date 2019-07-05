<template>
	<div class="update-article">
    <el-form ref="entity" :model="entity" :rules="ruleNew" :label-width="80" label-position="top">
      <el-form-item label="标题" prop="title">
          <el-input v-model="entity.title"></el-input>
      </el-form-item>
      <el-form-item label="详情" prop="content">
          <i-quill-editor class="editor" v-model="entity.content"></i-quill-editor>
      </el-form-item>
      <el-form-item>
          <el-button type="primary" @click="submit('entity')">发布</el-button>
      </el-form-item>
    </el-form>

    <el-dialog
      :visible.sync="modal"
      width="360px">
      <p slot="title" class="dialog-title">
        <i class="el-icon-info"></i>
        <span>温馨提示</span>
      </p>
      <div class="dialog-body">
        <p>是否修改？</p>
      </div>
      <div slot="footer">
          <el-button class="publish-button" type="warning" long :loading="modal_loading" @click="updateArticle()">确认</el-button>
      </div>
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
      articleId:null,
      modal:false,
      modal_loading: false,
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
  	this.articleId = this.$route.params.id;
  	this.getArticle(this.articleId);
  },
  methods: {
  	getArticle(e) {
	    this.axios({
	        method: "get",
	        url: "/public/articles/article/" + e
	    }).then(
	        function (response) {
	            this.entitySet(response.data.data);
	        }.bind(this)
	    ).catch(
	        function (error) {

	        }.bind(this)
	    );
	},
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
    updateArticle(){
      this.modal_loading =  true;
      this.axios({
        method: "put",
        url: "/article",
        data: {
        	id : this.articleId,
        	title : this.entity.title,
        	content : this.entity.content
        }
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
              this.$Message.error(response.data.message);
            }
            
          }.bind(this)
        ).catch(
          function(error) {
            this.$Message.error("新建失败");
          }.bind(this)
        );
    }
  }
};
</script>
<style type="text/css" scoped>
.update-article {
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