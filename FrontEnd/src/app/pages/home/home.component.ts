import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../services/group.service';
import { UserService } from '../../services/user.service';
import { FormsModule } from '@angular/forms';
import { PostService } from '../../services/post.service';
import { LikeService } from '../../services/like.service';
import { GlobalFunctionsService } from '../../services/global-functions.service';

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
  showCreateButton: boolean = false;
  filteredGroups: any[] = [];
  searchQuery: string = '';
  errorMessage: string = '';
  postData: any
  isConnected: boolean = false;
  likeCooldowns: { [postId: number]: number } = {}; // Ajouté pour le cooldown

  constructor(
    private groupService: GroupService,
    private likeService: LikeService, 
    private postService: PostService,
    private globalFunctions: GlobalFunctionsService, 
    private router: Router
  ) {}

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.userId = currentUser.id!;
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
        this.groups = data;
        this.filteredGroups = data;
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

  redirectToGroup(groupId: number): void {
    this.router.navigate(['/groups/view', groupId]);
  }

  redirectToCreate(): void {
    this.router.navigate(['/groups/create']);
  }

  onSearchChange(): void {
    if (this.searchQuery.trim() === '') {
      this.filteredGroups = this.groups;
    } else {
      this.filteredGroups = this.groups.filter((group) =>
        group.name.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  }
}

export default HomeComponent;