import { Component, OnDestroy } from '@angular/core';

// Services
import { GroupService } from '../../../services/group.service';
import { PostService } from '../../../services/post.service';
import { UserService } from '../../../services/user.service';
import { GlobalFunctionsService } from '../../../services/global-functions.service';

import { Router } from '@angular/router';
import { ActivatedRoute } from '@angular/router';
import { OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-group-view',
  imports: [CommonModule, FormsModule],
  templateUrl: './group-view.component.html',
  styleUrl: './group-view.component.css'
})
export class GroupViewComponent implements OnInit, OnDestroy {
  groupId!: number;
  private routeSub: Subscription = new Subscription();
  groupData: any;
  postData: any;
  showCreatePost = false;

  newPost = {
    title: '',
    text: '',
    location: '',
    media: null
  };
  mediaPreviewUrl: string | ArrayBuffer | null = null;
  isImage: boolean = true;

  members = [
    {
      name: 'Groupe Alpha',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 1h'
    },
    {
      name: 'Groupe Beta',
      image: 'https://via.placeholder.com/48',
      lastActivity: 'Il y a 3h'
    }
  ];

  constructor(
    private route: ActivatedRoute, 
    private groupService: GroupService, 
    private postService: PostService, 
    private userService: UserService, 
    private globalFunctions: GlobalFunctionsService
  ) {}

  ngOnInit(): void {
    this.routeSub = this.route.paramMap.subscribe(params => {
      this.groupId = Number(this.route.snapshot.paramMap.get('id'));

      this.groupService.getGroupById(this.groupId).subscribe({
        next: (data) => {
          this.groupData = data;
        },
        error: (error) => {
          console.error('Erreur lors de la récupération du groupe', error);
        }
      });

      this.postService.getGroupsByUser(this.groupId).subscribe({
        next: (data) => {
          if (data) {
            data.map((post: any) => {

              post['datetime'] = this.globalFunctions.formatRelativeDateFR(post['datetime'])

              this.userService.getUsernameByUserId(post['id_user']).subscribe({
                next: (data) => {
                  post['author'] = data['username'] || 'Inconnu';
                },
                error: (error) => {
                  console.error("Erreur lors de la récupération du nom d'utilisateur :", error);
                  post['author'] = 'Inconnu';
                }
              });
            })

            this.postData = data;
          }
        },
        error: (error) => {
          console.error('Erreur lors de la récupération des posts du groupe', error);
        }
      });

    });
  }

  ngOnDestroy() {
    this.routeSub.unsubscribe();
  }

  joinGroup(): void {
    // Logique pour rejoindre le groupe
    console.log('Rejoindre le groupe', this.groupId);
  }

  toggleCreatePost() {
    this.showCreatePost = !this.showCreatePost;
  }

  onMediaSelected(event: any) {
    const file = event.target.files[0];
    if (file) {
      this.newPost.media = file;
      const reader = new FileReader();

      reader.onload = () => {
        this.mediaPreviewUrl = reader.result;
        this.isImage = file.type.startsWith('image/');
      };

      reader.readAsDataURL(file);
    }
  }

  submitPost() {
    // Ajoute ici la logique pour envoyer le post (API, localStorage, etc.)
    console.log('Nouveau post:', this.newPost);
    // Réinitialisation
    this.newPost = { title: '', text: '', location: '', media: null };
  }

}