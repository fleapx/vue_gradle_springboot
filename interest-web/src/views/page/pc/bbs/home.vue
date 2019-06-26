<template>
    <div class="content-background">
      <div>
        <el-carousel trigger="click" height="550px">
          <el-carousel-item v-for="(item,index) in bannerList" :key="index">
            <router-link :to="('/page/detail/'+item.id)">
                <img  class="banner-images" v-bind:src="(item.image)">
              </router-link>
          </el-carousel-item>
        </el-carousel>
      </div>

      <div v-if="flage" class="search-nothing">
        <span>未找到符合条件的结果</span>
      </div>

      <div class="interest">
        <div class="info" v-for="(A,index) in homeArticle">
          <div class="box-flex width-100" v-if="index%2==0">
            <div class="image">
                <router-link :to="('/page/detail/'+A.id)">
                  <img v-bind:src="(A.image)">
                </router-link>
            </div>
            <div class="text-content">
                <router-link :to="('/page/detail/'+A.id)">
                  <span class="title">{{A.title}}</span>
                </router-link>
                <span class="content">{{A.info}}</span>
            </div>
          </div>
          <div class="box-flex width-100" v-else>
              <div class="text-content">
                  <router-link :to="('/page/detail/'+A.id)">
                    <span class="title">{{A.title}}</span>
                  </router-link>
                  <span class="content">{{A.info}}</span>
              </div>
              <div class="image">
                  <router-link :to="('/page/detail/'+A.id)">
                    <img v-bind:src="(A.image)">
                  </router-link>
              </div>
          </div>
        </div>
      </div>

    </div>
</template>
<script>
export default {
  data() {
    return {
      flage: false,
      value2: 0,
      homeArticle: [],
      bannerList: []
    };
  },
  mounted() {
    this.getHomeArticle();
    this.getBanner();
  },
  watch: {
    $route: ["getHomeArticle"]
  },
  methods: {
    getBanner() {
      this.axios({
        method: "get",
        url: "/public/banners"
      })
        .then(
          function(response) {
            this.bannerList = response.data.data;
          }.bind(this)
        )
        .catch(
          function(error) {
            this.$message({
              message: '无权限',
              type: 'error'
            });
          }.bind(this)
        );
    },
    getHomeArticle() {
      if (this.$route.params.title == null) {
        this.axios({
          method: "get",
          url: "/public/interests"
        })
          .then(
            function(response) {
              this.homeArticle = response.data.data;
            }.bind(this)
          )
          .catch(
            function(error) {
              this.$message({
                message: '无权限',
                type: 'error'
              });
            }.bind(this)
          );
      } else {
        this.axios({
          method: "get",
          url: "/public/interests",
          params: {
            title: this.$route.params.title
          }
        })
          .then(
            function(response) {
              this.homeArticle = response.data.data;
              if (this.homeArticle.length == 0) {
                this.flage = true;
              } else {
                this.flage = false;
              }
            }.bind(this)
          )
          .catch(
            function(error) {
              this.$message({
                message: '无权限',
                type: 'error'
              });
            }.bind(this)
          );
      }
    }
  }
};
</script>
<style scoped>
.banner-images {
  width: 100%;
  height: auto;
}
.interest {
  display: flex;
  display: -webkit-flex;
  flex-direction: column;
  margin-top: 3%;
}
.interest .info {
  display: flex;
  display: -webkit-flex;
  width: 80%;
  margin: 0 auto;
}
.interest .info .image{
  flex: 1;
}
.interest .info .image img {
  width: 100%;
  transition: 0.7s all;
  opacity: 0.8;
}
.interest .info .image img:hover {
  opacity: 1;
  box-shadow: 1px 1px 20px #333;
  transform: scale(1.1, 1.1);
  cursor: pointer;
}
.interest .info .text-content {
  display: flex;
  display: -webkit-flex;
  flex: 1;
  padding: 3%;
  flex-direction: column;
}
.interest .info .text-content .title {
  font-size: 140%;
  transition: 0.8s all;
}
.interest .info .text-content .title:hover {
  text-decoration: line-through;
  cursor: pointer;
}
.interest .info .text-content .content {
  font-size: 100%;
}
.interest .info .text-content a{
  text-decoration: none;
  color: #333;
}
.interest .info .text-content a:hover{
  color: #57a3f3;
}
.interest .info .text-content a:link, a:visited{
  text-decoration: none;
  border: 0;
}
.search-nothing {
  background: #fff;
  padding: 24px 50px;
  color: #495060;
  font-size: 16px;
  text-align: center;
}
.box-flex {
  display: flex;
  display: -webkit-flex;
}
.width-100 {
  width: 100%;
}
.content-background {
  background: #fff;
}
</style>