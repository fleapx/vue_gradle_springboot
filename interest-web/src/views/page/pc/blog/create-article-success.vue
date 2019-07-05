<template>
  <el-card class="card" shadow="never">
    <div class="cotent">
      <i class="el-icon-success success-icon"></i>
      <h3>文章发布成功</h3>
      <router-link :to="('/article/user')">
        <h4 class="link-text">返回我的文章</h4>
      </router-link>
    </div>
  </el-card>
</template>
<script>
export default {
  data() {
    return {
      
    };
  },
  mounted() {
    
  },
  methods: {
    
  }
};
</script>
<style scoped>
.card {
	height: 400px;
  width: 80%;
  margin: 0 auto;
}
.cotent{
	text-align:center;
	margin-top: 150px;
}
.cotent .link-text {
  color: rebeccapurple;
  margin-top: 20px;
}
.success-icon {
  color: #19be6b;
  font-size: 40px;
}
</style>
