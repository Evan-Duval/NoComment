import { Component, OnInit } from '@angular/core';
import { PostService } from '../../services/post.service';
import { CommentService } from '../../services/comment.service';
import { FormsModule } from '@angular/forms';
import { CommonModule } from '@angular/common';
import { GlobalFunctionsService } from '../../services/global-functions.service';
import { UserService } from '../../services/user.service';

@Component({
  selector: 'app-dashboard',
  imports: [CommonModule, FormsModule],
  templateUrl: './dashboard.component.html',
  styleUrl: './dashboard.component.css'
})
export class DashboardComponent implements OnInit {
  users: any[] = [];
  userRank: string = 'user';
  latestPosts: any[] = [];
  latestComments: any[] = [];

  notification: string = '';

  constructor(
    private userService: UserService,
    private postService: PostService,
    private commentService: CommentService,
    private globalFunctions: GlobalFunctionsService,
  ) {}

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.userRank = currentUser.rank;
    }

    this.userService.getAllUsers().subscribe({
      next: (users) => {
        users.map((user: any) => {
          user['created_at'] = this.globalFunctions.getFormttedDate(user['created_at'])
        });
        this.users = users 
      },
      error: (error) => {
        console.error('Error fetching users :', error);
        this.users = []
      }
    });

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
        comments.map((comment: any) => {
          comment['datetime'] = this.globalFunctions.formatRelativeDateFR(comment['datetime'])
        });
        this.latestComments = comments
      },
      error: () => this.latestComments = []
    });
  }

  handleDeletePost(postId: number) {
    this.postService.deletePost(postId).subscribe({
      next: () => {
        this.notification = 'Post supprimé avec succès !';
        window.location.reload();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la suppression du post.';
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }

  handleDeleteComment(commentId: number) {
    this.commentService.deleteComment(commentId).subscribe({
      next: () => {
        this.notification = 'Commentaire supprimé avec succès !';
        window.location.reload();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la suppression du commentaire.';
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }
}
