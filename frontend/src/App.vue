<template id="app">
  <div id="main">
    <div class="p-d-flex" id="mainDiv">
     <img src="@/assets/banner.png" alt="Banner Title" class="center" >
    </div>
    <router-view />
  </div>
  
</template>

<script>


export default {

}

</script>

<style>

html,
body {
  height: 100%;
  width: 100%;
  margin: 0;
  padding: 0;
  color: aliceblue;
  font-family: "Roboto Condensed";
}


#mainDiv{
  background-color: rgb(40, 40, 40, 0.7);
  margin-left: auto;
  margin-right: auto;
}


#main{
  background-image: url(~@/assets/background.jpg);
  background-repeat: no-repeat;
  background-size: cover;
  height: 100%;
}

#app{
  margin-left: 0;
  border: 0;
  height: 100%;
}
.center {
  display: block;
  margin-left: auto;
  margin-right: auto;
}


</style>
