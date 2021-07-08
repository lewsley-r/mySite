<template>
  <div class="home">
    <h1>
      Recent Posts
    </h1>
    <b-container class="bv-example-row">
      <b-row id="gridRow">
        <b-col>  
          <b-card
            img-src="@/assets/cardPostPic.jpg"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
          <b-card-title>
            {{ posts[0].title }}
          </b-card-title>
            <b-card-text>
              {{ posts[0].intro }}
            </b-card-text>

            <b-button href="#" variant="warning">View Post</b-button>
          </b-card>
        </b-col>
        <b-col>
          <b-card
            img-src="@/assets/cardPostPic.jpg"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-title>
              {{ posts[1].title }}
            </b-card-title>
            <b-card-text>
              {{ posts[1].intro }}
            </b-card-text>

            <b-button href="#" variant="warning">View Post</b-button>
          </b-card>
        </b-col>
        <b-col>
          <b-card
            img-src="@/assets/cardPostPic.jpg"
            img-alt="Image"
            img-top
            tag="article"
            style="max-width: 20rem;"
            class="mb-2"
          >
            <b-card-title>
              {{ posts[2].title }}
            </b-card-title>
            <b-card-text>
              {{ posts[2].intro }}
            </b-card-text>
            <b-button href="#" variant="warning">View Post</b-button>
          </b-card>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
// @ is an alias to /src


export default {
  name: 'home',
  data() {
    return{
      posts: [{
        title: "Post 1",
        pic: "@/asset/cardPostPic.jpg",
        intro: "Example post 1, just test content. Example post 1, just test content. Example post 1, just test content"
      },
      {
        title: "Post 2",
        pic: "@/asset/cardPostPic.jpg",
        intro: "Example post 2, just test content. Example post 2, just test content. Example post 2, just test content"

      },
      {
        title: "Post 3",
        pic: "@/asset/cardPostPic.jpg",
        intro: "Example post 3, just test content. Example post 3, just test content. Example post 3, just test content"

      }]
    }
  }
  
  
}
</script>

<style scoped>

</style>