<?php

namespace App\Http\Controllers;

use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Http\Request;
use App\Models\Posts;

class PostUploadController extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests;

    public function postToDB(Request $request) {
        $post = Posts::create($request->all());

        return (['message' => 'Task was successful' ]);

    }
}
