<template>
    <div class="home">

      <v-swipe :autoplay="3000" class="swipe" height="200">
        <v-swipe-item v-for="(item,index) in bannerList" :key="index">
          <router-link :to="('/mobile/detail/'+item.id)">
              <img :src="(item.image)">
          </router-link>
        </v-swipe-item>
      </v-swipe>

      <div class="interest">
        <div class="info" v-for="(A,index) in homeArticle">
          <div class="box-flex width-100" v-if="index%2==0">
            <div class="image">
                <router-link :to="('/mobile/detail/'+A.id)">
                  <img v-bind:src="(A.image)">
                </router-link>
            </div>
            <div class="text-content">
                <router-link :to="('/mobile/detail/'+A.id)">
                  <span class="title">{{A.title}}</span>
                </router-link>
                <span class="content">{{A.info}}</span>
            </div>
          </div>
          <div class="box-flex width-100" v-else>
              <div class="text-content">
                  <router-link :to="('/mobile/detail/'+A.id)">
                    <span class="title">{{A.title}}</span>
                  </router-link>
                  <span class="content">{{A.info}}</span>
              </div>
              <div class="image">
                  <router-link :to="('/mobile/detail/'+A.id)">
                    <img v-bind:src="(A.image)">
                  </router-link>
              </div>
          </div>
        </div>
      </div>

    </div>
</template>
<script>
import Swipe from 'vant/lib/swipe';
import SwipeItem from 'vant/lib/swipe-item';
import 'vant/lib/swipe/style';
import 'vant/lib/swipe-item/style';
export default {
  components: {
    'v-swipe': Swipe,
    'v-swipe-item' : SwipeItem
  },
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
            this.$message.error("无权限");
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
              this.$message.error("无权限");
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
              this.$message.error("无权限");
            }.bind(this)
          );
      }
    }
  }
};
</script>
<style scoped>
.home {
  padding: 10px 0;
}
.swipe img{
  width: 100%;
}
.box-flex {
  display: flex;
  display: -webkit-flex;
}
.interest {
  display: flex;
  display: -webkit-flex;
  flex-direction: column;
  margin-top: 10px;
}
.interest .info {
  display: flex;
  display: -webkit-flex;
  margin: 0 auto;
  background: #fff;
  margin-top: 10px;
  box-shadow: 0 2px 4px 0 rgba(0,0,0,.05);
}
.interest .info:first-child {
  margin-top: 0;
}
.interest .info .image{
  flex: 1;
}
.interest .info .image img {
  width: 100%;
  transition: 0.7s all;
  opacity: 0.8;
  display: block;
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
  font-size: 120%;
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
</style>