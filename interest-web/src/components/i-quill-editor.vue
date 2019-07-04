<style type="text/css">
</style>
<template>
  <div>
    <el-upload
      v-show="false"
      id="interest-editor"
      ref="upload"
      :headers="headers"
      action="/interest/upload/picture"
      name="picture"
      :show-file-list="false"
      :before-upload="handleBeforeUpload"
      :on-success="handleSuccess"
      
      >
      <el-button size="small" type="primary">上传图片</el-button>
    </el-upload>
    <!-- <Upload 
      v-show="false"
            id="interest-editor"
            ref="upload"
            :headers="headers"
            action="/interest/upload/picture"
            name="picture"
            :show-upload-list="false"
            :before-upload="handleBeforeUpload"
            :on-success="handleSuccess"
            :on-format-error="handleFormatError"
            :format="['jpg','jpeg','png']"
            :max-size="1024"
            :on-exceeded-size="handleMaxSize">
            <Button icon="ios-cloud-upload-outline">上传图片</Button>
        </Upload> -->
      <quill-editor
        :value="content" 
        ref="myQuillEditor" 
        :options="editorOption" 
        @blur="onEditorBlur($event)" 
        @focus="onEditorFocus($event)"
        @change="onEditorChange($event)"
        @input="onEditorInput">
      </quill-editor>
    </div>
</template>
<script>
    import VueQuillEditor, { Quill } from 'vue-quill-editor';
    import  ImageResize  from 'quill-image-resize-module';
    // import { ImageDrop } from 'quill-image-drop-module';
    //import Quill from 'quill';
    // Quill.register('modules/imageDrop', ImageDrop);
    Quill.register('modules/imageResize', ImageResize);

    var BaseImageFormat = Quill.import('formats/image');
    const ImageFormatAttributesList = [
        'alt',
        'height',
        'width',
        'style'
    ];

    class ImageFormat extends BaseImageFormat {
      static formats(domNode) {
        return ImageFormatAttributesList.reduce(function(formats, attribute) {
          if (domNode.hasAttribute(attribute)) {
            formats[attribute] = domNode.getAttribute(attribute);
          }
          return formats;
        }, {});
      }
      format(name, value) {
        if (ImageFormatAttributesList.indexOf(name) > -1) {
          if (value) {
            this.domNode.setAttribute(name, value);
          } else {
            this.domNode.removeAttribute(name);
          }
        } else {
          super.format(name, value);
        }
      }
    }

    Quill.register(ImageFormat, true);
    // 工具栏配置
    const toolbarOptions = [
      ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
      ['blockquote', 'code-block'],

      [{'header': 1}, {'header': 2}],               // custom button values
      [{'list': 'ordered'}, {'list': 'bullet'}],
      [{'script': 'sub'}, {'script': 'super'}],      // superscript/subscript
      [{'indent': '-1'}, {'indent': '+1'}],          // outdent/indent
      [{'direction': 'rtl'}],                         // text direction

      [{'size': ['small', false, 'large', 'huge']}],  // custom dropdown
      [{'header': [1, 2, 3, 4, 5, 6, false]}],

      [{'color': []}, {'background': []}],          // dropdown with defaults from theme
      [{'font': []}],
      [{'align': []}],
      ['link', 'image', 'video'],
      ['clean']                                         // remove formatting button
    ]
  export default {
        props: ['value'],
        watch: {
            value: function(newQuestion, oldQuestion) {
              // this.setContent(newQuestion);
              this.content = newQuestion;
            }
        },
        data () {
            return {
                content:this.value,
                headers:{
                    Authorization:'bearer '+ localStorage.getItem("currentUser_token")
                },
                editorOption: {
                    placeholder: '',
                    theme: 'snow',  // or 'bubble'
                    modules: {
                        toolbar: {
                            container: toolbarOptions,  // 工具栏
                            handlers: {
                                'image': function (value) {
                                    if (value) {
                                        document.querySelector('#interest-editor Button').click()
                                    } else {
                                        this.quill.format('image', false);
                                    }
                                }.bind(this)
                            }
                        },
                        // imageDrop: true,
                        imageResize: {
                            displayStyles: {
                                backgroundColor: 'black',
                                border: 'none',
                                color: 'white'
                            },
                            modules: [ 'Resize', 'DisplaySize', 'Toolbar' ]
                            // displaySize: true
                        }
                    }
                }
            }
        },
        mounted(){
        },
        methods:{
            handleSuccess (res, file) {
                // 获取富文本组件实例
                let quill = this.$refs.myQuillEditor.quill;
                // 获取光标所在位置
                let length = quill.getSelection().index;
                // 插入图片  res.info为服务器返回的图片地址
                quill.insertEmbed(length, 'image', res.data);
                // 调整光标到最后
                //quill.setSelection(length + 1)
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
              
              // this.$refs.upload.fileList.splice(0, this.$refs.upload.fileList.length);
              // return true;
            },
            onEditorBlur(){//失去焦点事件
              this.$emit('editor-change',this.content);
            },
            onEditorFocus(){//获得焦点事件
              this.$emit('editor-change',this.content);
            },
            onEditorChange(val){//内容改变事件
              this.$emit('editor-change',this.content);
            },
            onEditorInput(val){
              this.content = val;
              this.$emit('input',this.content);
            }
        }
    }
</script>