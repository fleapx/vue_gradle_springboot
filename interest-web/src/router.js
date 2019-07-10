import Vue from "vue";
import VueRouter from "vue-router";
import iView from "iview";

Vue.use(VueRouter);

const routers = [
  {
    path: "/test",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/console/base.vue"], resolve),
    children: [
      {
        path: "",
        name: "welcome",
        component: resolve => require(["./views/test.vue"], resolve),
        meta: {
          title: "welcome"
        }
      }
    ]
  },
  {
    path: "*",
    component: resolve => require(["./views/error404.vue"], resolve)
  },
  {
    path: "/",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/page/pc/index.vue"], resolve),
    children: [
      {
        path: "",
        name: "home",
        component: resolve => require(["./views/page/pc/bbs/home.vue"], resolve),
        meta: {
          title: "home"
        }
      }
    ]
  },
  {
    path: "/qq",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/page/pc/index.vue"], resolve),
    children: [
      {
        path: "",
        name: "qq-home",
        component: resolve => require(["./views/page/pc/bbs/home.vue"], resolve),
        meta: {
          title: "home"
        }
      }
    ]
  },
  {
    path: "/login",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/login.vue"], resolve)
  },
  {
    path: "/page",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/page/pc/index.vue"], resolve),
    children: [
      {
        path: "home",
        name: "page-home",
        component: resolve => require(["./views/page/pc/bbs/home.vue"], resolve),
        meta: {
          title: "home"
        }
      },
      {
        path: "home/:title",
        name: "page-home-title",
        component: resolve => require(["./views/page/pc/bbs/home.vue"], resolve),
        meta: {
          title: "home"
        }
      },
      {
        path: "detail/:id",
        name: "page-detail-id",
        component: resolve => require(["./views/page/pc/bbs/detail.vue"], resolve),
        meta: {
          title: "detail"
        }
      },
      {
        path: "card/:id",
        name: "page-card-id",
        component: resolve => require(["./views/page/pc/bbs/card.vue"], resolve),
        meta: {
          title: "card"
        }
      },
      {
        path: "messages",
        name: "page-messages",
        component: resolve =>
          require(["./views/page/pc/bbs/messages.vue"], resolve),
        meta: {
          title: "messages"
        }
      },
      {
        path: "user",
        name: "page-user",
        component: resolve =>
          require(["./views/page/pc/bbs/user-info.vue"], resolve),
        meta: {
          title: "user"
        }
      },
      {
        path: "user/:id",
        name: "page-user-id",
        component: resolve =>
          require(["./views/page/pc/user-page.vue"], resolve),
        meta: {
          title: "user"
        }
      }
    ]
  },
  {
    path: "/mobile/login",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/mlogin.vue"], resolve)
  },
  {
    path: "/mobile",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/page/mobile/index.vue"], resolve),
    children: [
      {
        path: "",
        name: "mobile-home",
        component: resolve => require(["./views/page/mobile/home.vue"], resolve),
        meta: {
          title: "home"
        }
      },
      {
        path: "home/:title",
        name: "mobile-home-title",
        component: resolve => require(["./views/page/mobile/home.vue"], resolve),
        meta: {
          title: "home"
        }
      },
      {
        path: "detail/:id",
        name: "mobile-detail-id",
        component: resolve => require(["./views/page/mobile/detail.vue"], resolve),
        meta: {
          title: "detail"
        }
      },
      {
        path: "card/:id",
        name: "mobile-card-id",
        component: resolve => require(["./views/page/mobile/card.vue"], resolve),
        meta: {
          title: "card"
        }
      },
      {
        path: "messages",
        name: "mobile-messages",
        component: resolve => require(["./views/page/mobile/messages.vue"], resolve),
        meta: {
          title: "messages"
        }
      },
      {
        path: "article",
        name: "mobile-article",
        component: resolve => require(["./views/page/mobile/article.vue"], resolve),
        meta: {
          title: "article"
        }
      },{
        path: "article/detail/:id",
        name: "mobile-article-detail",
        component: resolve => require(["./views/page/mobile/article-detail.vue"], resolve),
        meta: {
          title: "detail"
        }
      },{
        path: "user/:id",
        name: "mobile-user-page",
        component: resolve => require(["./views/page/mobile/user-page.vue"], resolve),
        meta: {
          title: "user"
        }
      }
    ]
  },
  {
    path: "/base",
    meta: {
      title: "base",
      requiresAuth: true
    },
    component: resolve => require(["./views/console/base.vue"], resolve),
    children: [
      {
        path: "",
        name: "welcome",
        component: resolve => require(["./views/console/welcome.vue"], resolve),
        meta: {
          title: "welcome"
        }
      },
      {
        path: "menu",
        name: "menu",
        component: resolve => require(["./views/console/sys/menu.vue"], resolve),
        meta: {
          title: "menu"
        }
      },
      {
        path: "role",
        name: "role",
        component: resolve => require(["./views/console/sys/role.vue"], resolve),
        meta: {
          title: "role"
        }
      },
      {
        path: "user",
        name: "user",
        component: resolve => require(["./views/console/sys/user.vue"], resolve),
        meta: {
          title: "user"
        }
      },
      {
        path: "email",
        name: "email",
        component: resolve => require(["./views/console/email/email.vue"], resolve),
        meta: {
          title: "email"
        }
      },
      {
        path: "card",
        name: "cardmanage",
        component: resolve => require(["./views/console/card.vue"], resolve),
        meta: {
          title: "card"
        }
      },
      {
        path: "i-edit",
        name: "interest-edit",
        component: resolve =>
          require(["./views/console/interest/interest-edit.vue"], resolve),
        meta: {
          title: "interest"
        }
      },
      {
        path: "i-create",
        name: "interest-create",
        component: resolve =>
          require(["./views/console/interest/interest-create.vue"], resolve),
        meta: {
          title: "interest"
        }
      },
      {
        path: "i-delete",
        name: "interest-delete",
        component: resolve =>
          require(["./views/console/interest/interest-delete.vue"], resolve),
        meta: {
          title: "interest"
        }
      },
      {
        path: "banner",
        name: "banner",
        component: resolve => require(["./views/console/banner/banner.vue"], resolve),
        meta: {
          title: "banner"
        }
      },
      {
        path: "article",
        name: "article",
        component: resolve => require(["./views/console/article.vue"], resolve),
        meta: {
          title: "article"
        }
      }
    ]
  },
  {
    path: "/article",
    meta: {
      title: "smallsnail-wh"
    },
    component: resolve => require(["./views/page/pc/index.vue"], resolve),
    children: [
      {
        path: "",
        name: "article-home",
        component: resolve => require(["./views/page/pc/blog/home.vue"], resolve),
        meta: {
          title: "article"
        }
      },
      {
        path: "create",
        name: "article-create",
        component: resolve => require(["./views/page/pc/blog/create-article.vue"], resolve),
        meta: {
          title: "article"
        }
      },
      {
        path: "create/success",
        name: "article-create",
        component: resolve => require(["./views/page/pc/blog/create-article-success.vue"], resolve),
        meta: {
          title: "article"
        }
      },
      {
        path: "detail/:id",
        name: "article-detail-id",
        component: resolve => require(["./views/page/pc/blog/article-detail.vue"], resolve),
        meta: {
          title: "article"
        }
      },
      {
        path: "user",
        name: "article-user",
        component: resolve => require(["./views/page/pc/blog/user-article.vue"], resolve),
        meta: {
          title: "article"
        }
      },
      {
        path: "update/:id",
        name: "article-update-id",
        component: resolve => require(["./views/page/pc/blog/update-article.vue"], resolve),
        meta: {
          title: "article"
        }
      }
    ]
  }
];

// 路由配置
const RouterConfig = {
  mode: "history",
  routes: routers
};
const router = new VueRouter(RouterConfig);

router.beforeEach((to, from, next) => {
  
    let toMobile = to.fullPath.startsWith('/mobile');
    let isMobile = navigator.userAgent.match(
      /(phone|pad|pod|iPhone|iPod|ios|iPad|Android|Mobile|BlackBerry|IEMobile|MQQBrowser|JUC|Fennec|wOSBrowser|BrowserNG|WebOS|Symbian|Windows Phone)/i
    );
    if(!toMobile && isMobile){
      next('/mobile');
    }else if(toMobile && !isMobile){
      next('/');
    }
    
  iView.LoadingBar.start();
  next();
});

router.afterEach(() => {
  iView.LoadingBar.finish();
  window.scrollTo(0, 0);
});

export default router;
