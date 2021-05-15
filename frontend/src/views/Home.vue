<template id="home">
  <div :style="{'background-image':'url(~@/assets/background.jpg)'}">
    <div class="p-mr-2">
      <Menu id="menu" :model="items" />
    </div>
    <div class="p-mr-2" id="boxMain">
      <DataView :value="posts" :layout="layout" :paginator="true" :rows="9" :sortOrder="sortOrder" :sortField="sortField">
        <template #grid="slotProps">
          <div class="p-col-12 p-md-4">
     
          </div>
        </template>
      </DataView>
      
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
            ],
        posts: []
      }
    },
    mounted(){

    }
 
	
}

</script>

<style scoped>
  #home{
    font-family: Courier New (monospace);
    background-color: whitesmoke;
    height: 1532px;
    width: 2550px;
    margin: 0;
  }
  #menu{
  opacity: 80%;    
  }
  #panel1{
    background-color: whitesmoke;
  }
  #panel2{
    background-color: whitesmoke;
  }
  #panel3{
    background-color: black;
  }
  #panel4{
    background-color: aliceblue;
  }
  #tbm{
    background-color: cornflowerblue;
  }
</style>
