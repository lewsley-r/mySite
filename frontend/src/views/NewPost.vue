<template>
    <div class="p-d-flex">
        <div class="p-mr-2">
        <Menu id="menu" :model="items" />
        </div>
        <div class="p-mr-2" id="boxMain">
            <span class="p-float-label">
                <InputText id="post-id" type="text" v-model="postTitle" />
                <label for="post-id">Post Title</label>
            </span>
            <br>
            <br>
            <Editor v-model="content" >
                <template #toolbar>
                    <span class="ql-formats">
                        <button class="ql-bold"></button>
                        <button class="ql-italic"></button>
                        <button class="ql-underline"></button>
                        <Button id="sub" icon="pi pi-check" @click="handleClick" v-tooltip="'Click to submit Post'" />
                    </span>
                </template>
            </Editor>
        
        </div>
    </div>

</template>

<script>
import axios from 'axios'

export default {
    data() {
        return {
            content: null,
            postTitle: null,
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
    },
    methods: {
        handleClick() {
            console.log(this.content, this.postTitle)
            axios.post('/api/newPosts', {
                postContent: this.content,
                postTitle: this.postTitle
            }).then(function (response) {
                console.log(response);
                window.location='/home'
            })
            .catch(function (error) {
                console.log(error);
            });
            alert('Post Submitted')
        }
    }

}
</script>

<style>
    #sub{
        color: whitesmoke;
    }
    #boxMain{
    margin-top: 3vh;
    margin-left: 40vh;
    height: 20vh;
    width: 100vh;
  
    }
</style>