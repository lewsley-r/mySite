<template>
<div class="p-d-flex">
    <div class="p-mr-2">
      <Menu id="menu" :model="items" />
    </div>
    <div class="p-mr-2" id="boxMain">
      <div class="p-d-flex" style="text-align: center; margin-left: 5vw;">
          <div class="p-mr-2 p-mb-2" style="height: 10%">
            <h1 id="textMain"> About Me</h1>
          </div>
          <div class="p-mr-2 p-mb-2" style="height: 10%">
            <img src="@/assets/me.jpg" alt="Photo of me" id="photo">
          </div>
      </div>
      <p id="textMain">
        Hi, my name is Ronan Lewsley, i'm currently 22 years old and completing my 3rd of my 4 year Computer Science degree. Being in my third year I am currently on full-time work placement as a Junior Developer at Flax & Teal Ltd. During my time i've gained the skills necessary to create this site. For more information of the sites set-up go to my GitHub Repo linked to left.
        &nbsp;
        Some Key Technologies of these that I have gained a large amount of exposure to are;
        &nbsp;
        PHP (Laravel),
        JS (Vue.JS),
        Docker,
        Postgresql,
        Python and
        Kubernetes

      </p>
    </div>
</div>
</template>

<script>
export default {
    data() {
		return {
			 items: [
                {
                    items: [{
                      label: 'Home',
                      icon: 'pi pi-home',
                      url: '/home'
                    },
                    {
                      label: 'LinkedIn',
                      icon: 'pi pi-user',
                      url: 'https://www.linkedin.com/in/ronan-lewsley-9b1bbb199'
                    },
                    {
                      label: 'About Me',
                      icon: 'pi pi-book',
                      to: '/about'
                    },
                    {
                      label: 'Github',
                      icon: 'pi pi-github',
                      url: 'https://github.com/lewsley-r/mySite'
                    }
                ]}
            ]
      }
    }
}
</script>

<style>
  #boxMain {
    border-radius: 20%;
    margin-top: 3vh;
    margin-left: 40vh;
    top: 20vh;
    background-color: rgb(40, 40, 40, 0.7);
    height: 80vh;
    width: 100vh;
  }
  #textMain{
    margin: 8vh;
    font-family: "Roboto Mono";
  }
  #photo{
    margin-top: 8vh;
    height: 10vh;
    border-radius: 60%;
  }

</style>
