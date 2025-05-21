import { Component, OnInit } from '@angular/core';
import { PostService } from '../../services/post.service';
import { CommentService } from '../../services/comment.service';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { GlobalFunctionsService } from '../../services/global-functions.service';

@Component({
  selector: 'app-dashboard',
  imports: [CommonModule, FormsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent implements OnInit {
  latestPosts: any[] = [];
  latestComments: any[] = [];

  constructor(
    private postService: PostService,
    private commentService: CommentService,
    private globalFunctions: GlobalFunctionsService,
  ) {}

  ngOnInit(): void {
    // Ajouter vérification admin

    this.postService.getLastPosts().subscribe({
      next: (posts) => {
        posts.map((post: any) => {
          post['datetime'] = this.globalFunctions.formatRelativeDateFR(post['datetime'])
        });
        
        this.latestPosts = posts
      },
      error: () => {
        console.error('Error fetching posts');
        this.latestPosts = []
      }
    });

    this.commentService.getLastComments().subscribe({
      next: (comments) => {
        console.log(comments);
        comments.map((comment: any) => {
          comment['datetime'] = this.globalFunctions.formatRelativeDateFR(comment['datetime'])
        });
        this.latestComments = comments
      },
      error: () => this.latestComments = []
    });
  }
}
