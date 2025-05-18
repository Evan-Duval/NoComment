import { Component, OnDestroy } from '@angular/core';

// Services
import { GroupService } from '../../../services/group.service';
import { PostService } from '../../../services/post.service';
import { UserService } from '../../../services/user.service';
import { GlobalFunctionsService } from '../../../services/global-functions.service';

import { ActivatedRoute, Router } from '@angular/router';
import { OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { Subscription } from 'rxjs';
import { LikeService } from '../../../services/like.service';
import { CommentService } from '../../../services/comment.service';

@Component({
  selector: 'app-group-view',
  imports: [CommonModule, FormsModule],
  templateUrl: './group-view.component.html',
  styleUrl: './group-view.component.css'
})
export class GroupViewComponent implements OnInit, OnDestroy {
  globalErrorMessage: string = '';
  errorMessage: string = '';
  groupId!: number;
  userId!: number;
  username!: string;
  private routeSub: Subscription = new Subscription();
  members: any[] = [];
  filteredMembers: any[] = [];
  searchQuery: string = '';
  groupData: any;
  postData: any;
  showCreatePost = false;
  hasJoinedGroup!: boolean;
  isConnected: boolean = false;

  newPost = {
    title: '',
    text: '',
    location: '',
    media: null,
    datetime: '',
    id_user: this.userId,
    id_group: this.groupId
  };
  mediaPreviewUrl: string | ArrayBuffer | null = null;
  isImage: boolean = true;
  likeCooldowns: { [postId: number]: number } = {}; // Ajouté pour le cooldown
  commentLikeCooldowns: { [commentId: number]: number } = {}; // Cooldown pour les likes de commentaires

  showCommentsPopup = false;
  selectedPost: any = null;
  comments: any[] = [];
  newCommentText: string = '';

  constructor(
    private route: ActivatedRoute, 
    private groupService: GroupService, 
    private postService: PostService, 
    private commentService: CommentService,
    private userService: UserService, 
    private likeService: LikeService,
    private globalFunctions: GlobalFunctionsService,
    private router: Router,
  ) {}

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;

    if (currentUser) {
      this.userId = currentUser.id!;
      this.username = currentUser.username;
      this.isConnected = true;
    } else {
      console.error('Utilisateur non trouvé dans le service global');
    }

    // Charger les données du groupe
    this.routeSub = this.route.paramMap.subscribe(params => {
      this.groupId = Number(this.route.snapshot.paramMap.get('id'));
      this.hasJoinedGroup = false;

      this.groupService.getGroupById(this.groupId).subscribe({
        next: (data) => {
          if (!data) {
            this.globalErrorMessage = 'Aucun groupe trouvé avec cet ID.';
            return;
          }
          this.groupData = data;
        },
        error: (error) => {
          this.globalErrorMessage = 'Erreur lors de la récupération du groupe';
          console.error('Erreur lors de la récupération du groupe', error);
          return;
        }
      });

      // Vérifier si l'utilisateur a rejoint le groupe
      this.groupService.getGroupMembers(this.groupId).subscribe({
        next: (data) => {
          this.members = data;
          this.filteredMembers = data;
          this.hasJoinedGroup = this.members.some((member: any) => member.id === this.userId);
        },
        error: (error) => {
          this.globalErrorMessage = 'Erreur lors de la récupération des membres du groupe';
          console.error(error);
          return;
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
                  console.error(error);
                  post['author'] = 'Inconnu';
                  return;
                }
              });

              this.likeService.getLikesByPost(post['id_post'], this.userId).subscribe({
                next: (data) => {
                  post['likes'] = data['like_number'] || 0;
                  post['liked'] = data['user_like'] || false;
                },
                error: (error) => {
                  console.error(error);
                  post['likes'] = 0;
                  return;
                }
              });

              this.commentService.getCommentNumberByPost(post['id_post']).subscribe({
                next: (data) => {
                  post['commentsNumber'] = data['comment_number'] || 0;
                },
                error: (error) => {
                  console.error(error);
                  post['commentsNumber'] = 0;
                  return;
                }
              });
              // ajouter likes et commentaires du post ici
            })

            this.postData = data;
          }
        },
        error: (error) => {
          this.globalErrorMessage = 'Erreur lors de la récupération des posts du groupe';
          console.error(error);
          return;
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

  leaveGroup(): void {
    console.log('Quitter le groupe');
    // Logique à implémenter plus tard
  }

  redirectToUserProfile(userId: number) {
      this.router.navigate(['/profil', userId]);
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
    // Validation des champs
    if (!this.newPost.title || !this.newPost.text || !this.newPost.location) {
      this.errorMessage = 'Tous les champs doivent être remplis avant de soumettre le post.';
      return;
    }

    // Récupérer la date actuelle au format SQL
    this.newPost.datetime = this.globalFunctions.getCurrentDateTimeSQL();
    this.newPost.id_user = this.userId;
    this.newPost.id_group = this.groupId;

    this.postService.createPost(this.newPost).subscribe({
      next: (data) => {
        data['author'] = this.username;
        data['datetime'] = this.globalFunctions.formatRelativeDateFR(data['datetime'])

        this.postData = [data, ...this.postData];
        this.showCreatePost = false;

        // Réinitialiser le formulaire après soumission
        this.newPost = { title: '', text: '', location: '', media: null, datetime: '', id_user: this.userId, id_group: this.groupId };
      },
      error: (error) => {
        console.error('Erreur lors de la création du post:', error);
        this.errorMessage = 'Une erreur est survenue lors de la création du post.';
      }
    });
  }

  onSearchChange(): void {
    if (this.searchQuery.trim() === '') {
      this.filteredMembers = this.members; // Réinitialiser si la recherche est vide
    } else {
      this.filteredMembers = this.members.filter((member) =>
        member.username.toLowerCase().includes(this.searchQuery.toLowerCase())
      );
    }
  }

  onLikeButtonDown(post: any) {
    const now = Date.now();
    const lastClick = this.likeCooldowns[post.id_post] || 0;
    if (now - lastClick < 500) {
      // Cooldown de 0.5 seconde
      return;
    }
    this.likeCooldowns[post.id_post] = now;
    if (post.liked) {
      this.likeService.unlikePost(post.id_post, this.userId).subscribe({
        next: () => {
          post.liked = false;
          post.likes = (post.likes || 1) - 1;
        },
        error: (err) => {
          console.error('Erreur lors du unlike', err);
        }
      });
    } else {
      this.likeService.likePost(post.id_post, this.userId).subscribe({
        next: () => {
          post.liked = true;
          post.likes = (post.likes || 0) + 1;
        },
        error: (err) => {
          console.error('Erreur lors du like', err);
        }
      });
    }
  }

  openCommentsPopup(post: any) {
    this.selectedPost = post;
    this.showCommentsPopup = true;

    this.commentService.getCommentsByPost(post['id_post']).subscribe({
      next: (data) => {
        if (!data) {
          this.comments = [];
          return;
        }
        data.forEach((comment: any) => {
          comment['datetime'] = this.globalFunctions.formatRelativeDateFR(comment['datetime']);
          this.userService.getUsernameByUserId(comment['id_user']).subscribe({
            next: (data) => {
              comment['author'] = data['username'] || 'Inconnu';
            },
            error: (error) => {
              console.error(error);
              comment['author'] = 'Inconnu';
            }
          });
          // Récupère likes pour chaque commentaire
          this.likeService.getLikesByComment(comment.id_comment, this.userId).subscribe({
            next: (likeData) => {
              comment.likes = likeData.like_number || 0;
              comment.liked = likeData.user_like || false;
            },
            error: () => {
              comment.likes = 0;
              comment.liked = false;
            }
          });
        });
        this.comments = data;
      },
      error: (error) => {
        console.error(error);
        this.comments = [];
      }
    });
  }

  closeCommentsPopup() {
    this.showCommentsPopup = false;
    this.selectedPost = null;
    this.comments = [];
    this.newCommentText = '';
  }

  addComment() {
    if (!this.newCommentText.trim()) return;
    this.commentService.addComment({
      text: this.newCommentText,
      id_user: this.userId,
      id_post: this.selectedPost.id_post,
      datetime: this.globalFunctions.getCurrentDateTimeSQL()
    }).subscribe({
      next: (newCommentData) => {
        newCommentData['datetime'] = this.globalFunctions.formatRelativeDateFR(newCommentData['datetime'])
        newCommentData['author'] = this.username;

        this.comments.unshift(newCommentData);
        this.newCommentText = '';

        const postIndex = this.postData.findIndex(
          (post: any) => post.id_post === this.selectedPost.id_post
        );
        if (postIndex !== -1) {
          this.postData[postIndex].commentsNumber = (this.postData[postIndex].commentsNumber || 0) + 1;
        }
      }
    });
  }

  onLikeComment(comment: any) {
    if (!this.isConnected || !this.hasJoinedGroup) return;

    if (!this.commentLikeCooldowns) this.commentLikeCooldowns = {};
    const now = Date.now();
    const lastClick = this.commentLikeCooldowns[comment.id_comment] || 0;
    if (now - lastClick < 500) return; // cooldown de 0.5 seconde
    this.commentLikeCooldowns[comment.id_comment] = now;

    if (comment.liked) {
      this.likeService.unLikeComment(comment.id_comment, this.userId).subscribe({
        next: () => {
          comment.liked = false;
          comment.likes = (comment.likes || 1) - 1;
        },
        error: (err) => {
          console.error('Erreur lors du unlike commentaire', err);
        }
      });
    } else {
      this.likeService.likeComment(comment.id_comment, this.userId).subscribe({
        next: () => {
          comment.liked = true;
          comment.likes = (comment.likes || 0) + 1;
        },
        error: (err) => {
          console.error('Erreur lors du like commentaire', err);
        }
      });
    }
  }
}