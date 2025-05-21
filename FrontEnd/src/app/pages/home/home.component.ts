import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../services/group.service';
import { UserService } from '../../services/user.service';
import { FormsModule } from '@angular/forms';
import { PostService } from '../../services/post.service';
import { LikeService } from '../../services/like.service';
import { GlobalFunctionsService } from '../../services/global-functions.service';
import { SupabaseService } from '../../services/supabase.service';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.css']
})
export class HomeComponent implements OnInit {
  groups: any[] = [];
  userToken: string | null = localStorage.getItem('token');
  userId: number = 0;
  userRank: string = 'user';
  showCreateButton: boolean = false;
  filteredGroups: any[] = [];
  searchQuery: string = '';
  errorMessage: string = '';
  postData: any
  isConnected: boolean = false;
  likeCooldowns: { [postId: number]: number } = {};

  notification: string = '';

  constructor(
    private groupService: GroupService,
    private likeService: LikeService, 
    private postService: PostService,
    private globalFunctions: GlobalFunctionsService, 
    private supabaseService: SupabaseService,
    private router: Router
  ) {}

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.userId = currentUser.id!;
      this.userRank = currentUser.rank
      this.isConnected = true;
      this.loadGroups();
      this.loadLastPosts();
    } else {
      this.showCreateButton = true;
      this.loadLastPosts();
    }
  }

  loadGroups(): void {
    this.groupService.getGroupsByUser(this.userId).subscribe({
      next: (data) => {
        this.groups = this.groups = data.map((group: any) => ({
          ...group,
          logoUrl: this.supabaseService.getPublicMediaUrl(group.logo)
        }));

        this.filteredGroups = this.groups = data.map((group: any) => ({
          ...group,
          logoUrl: this.supabaseService.getPublicMediaUrl(group.logo)
        }));
        
        this.showCreateButton = this.groups.length === 0;
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des groupes', error);
        this.showCreateButton = true;
      }
    });
  }

  loadLastPosts(): void {
    this.postService.getLastPosts().subscribe({
      next: (data) => {
        this.postData = data;
        if (data) {
          data.map((post: any) => {
            post['datetime'] = this.globalFunctions.formatRelativeDateFR(post['datetime'])
            post['likes'] = post['likesCount'] || 0;
            post['isLiked'] = post['isLiked'] || false;
          });
        }
      },
      error: (error) => {
        console.error('Erreur lors de la récupération des derniers posts', error);
      }
    });
  };

  redirectToGroups() {
    this.router.navigate(['/groups'])
  }

  redirectToGroup(groupId: number) {
    this.router.navigate(['/groups/view', groupId]);
  }

  redirectToCreate() {
    this.router.navigate(['/groups/create']);
  }

  onSearchChange() {
    if (this.searchQuery.trim() === '') {
      this.filteredGroups = this.groups;
    } else {
      this.filteredGroups = this.groups.filter((group) =>
        group.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  }

  handlePostVerification(postId: number) {
    this.postService.updatePost(postId).subscribe({
      next: () => {
        this.notification = 'Post modifié avec succès !';
        this.loadLastPosts();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la modification du post.';
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }

  handleDeletePost(postId: number) {
    this.postService.deletePost(postId).subscribe({
      next: () => {
        this.notification = 'Post supprimé avec succès !';
        this.loadLastPosts();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la suppression du post.';
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }
}

export default HomeComponent;