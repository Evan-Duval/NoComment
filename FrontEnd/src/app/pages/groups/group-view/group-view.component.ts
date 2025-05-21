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
import { SupabaseService } from '../../../services/supabase.service';

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
  userRank: string = "user";
  private routeSub: Subscription = new Subscription();
  members: any[] = [];
  filteredMembers: any[] = [];
  searchQuery: string = '';
  groupData: any;
  postData: any;
  showCreatePost = false;
  hasJoinedGroup!: boolean;
  isConnected: boolean = false;

  selectedFile: File | null = null;
  newPost = {
    title: '',
    text: '',
    location: '',
    media: '',
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

  notification: string = '';

  editPostId: number | null = null;
  editPostData: any = { title: '', text: '', location: '' };
  editErrorMessage: string = '';

  constructor(
    private route: ActivatedRoute, 
    private groupService: GroupService, 
    private postService: PostService, 
    private commentService: CommentService,
    private userService: UserService, 
    private likeService: LikeService,
    private globalFunctions: GlobalFunctionsService,
    private supabaseService: SupabaseService,
    private router: Router,
  ) {}

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;

    if (currentUser) {
      this.userId = currentUser.id!;
      this.username = currentUser.username;
      this.userRank = currentUser.rank;
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
          if (data.logo) {
            data.logoUrl = this.supabaseService.getPublicMediaUrl(data.logo);
          } else {
            data.logoUrl = 'default_logo.png';
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
              post['media'] = post.media ? this.supabaseService.getPublicMediaUrl(post.media) : null;
              post['datetime'] = this.globalFunctions.formatRelativeDateFR(post['datetime'])
              post['likes'] = post['likesCount'] || 0;
              post['isLiked'] = post['isLiked'] || false;
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

  toggleFollowGroup(): void {
    console.log(this.groupData)
    this.groupService.toggleFollowGroup(this.groupData.id_group, this.groupData).subscribe({
      next: (data) => {
        console.log(data)
        this.hasJoinedGroup = !this.hasJoinedGroup;
        if (this.hasJoinedGroup) {
          this.globalErrorMessage = 'Vous avez rejoint le groupe.';
        } else {
          this.globalErrorMessage = 'Vous avez quitté le groupe.';
        }

        window.location.reload();
      },
      error: (error) => {
        console.error('Erreur lors de la mise à jour du groupe', error);
        this.globalErrorMessage = 'Erreur lors de la mise à jour du groupe';
      }
    });
  }

  redirectToUserProfile(userId: number) {
      this.router.navigate(['/profil', userId]);
  }

  toggleCreatePost() {
    this.showCreatePost = !this.showCreatePost;
  }

  onMediaSelected(event: Event) {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.selectedFile = input.files[0];
    }
  }

  async submitPost() {
    // Validation des champs
    if (!this.newPost.title || !this.newPost.text || !this.newPost.location) {
      this.errorMessage = 'Tous les champs doivent être remplis avant de soumettre le post.';
      return;
    }

    // Récupérer la date actuelle au format SQL
    this.newPost.datetime = this.globalFunctions.getCurrentDateTimeSQL();
    this.newPost.id_user = this.userId;
    this.newPost.id_group = this.groupId;

    if (this.selectedFile) {
      const fileName = `${Date.now()}_${this.selectedFile.name}`;
      const { error } = await this.supabaseService.client
        .storage
        .from('nocomment') // ← nom du bucket
        .upload(`${fileName}`, this.selectedFile);

      if (error) {
        console.error('Erreur upload Supabase :', error.message);
        return;
      }

      this.newPost.media = `${fileName}`; // ← chemin stocké en DB
    } else {
      this.newPost.media = '';
    }

    this.postService.createPost(this.newPost).subscribe({
      next: (data) => {
        data['username'] = this.username;
        data['datetime'] = this.globalFunctions.formatRelativeDateFR(data['datetime'])

        this.postData = [data, ...this.postData];
        this.showCreatePost = false;

        // Réinitialiser le formulaire après soumission
        this.newPost = { title: '', text: '', location: '', media: '', datetime: '', id_user: this.userId, id_group: this.groupId };
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
    const lastClick = this.likeCooldowns[post.id] || 0;
    if (now - lastClick < 500) {
      // Cooldown de 0.5 seconde
      return;
    }
    this.likeCooldowns[post.id] = now;
    if (post.isLiked) {
      this.likeService.unlikePost(post.id, this.userId).subscribe({
        next: () => {
          post.isLiked = false;
          post.likes = (post.likes || 1) - 1;
        },
        error: (err) => {
          console.error('Erreur lors du unlike', err);
        }
      });
    } else {
      this.likeService.likePost(post.id, this.userId).subscribe({
        next: () => {
          post.isLiked = true;
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

    this.commentService.getCommentsByPost(post['id']).subscribe({
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
      id_post: this.selectedPost.id,
      datetime: this.globalFunctions.getCurrentDateTimeSQL()
    }).subscribe({
      next: (newCommentData) => {
        newCommentData['datetime'] = this.globalFunctions.formatRelativeDateFR(newCommentData['datetime'])
        newCommentData['author'] = this.username;

        this.comments.unshift(newCommentData);
        this.newCommentText = '';

        const postIndex = this.postData.findIndex(
          (post: any) => post.id === this.selectedPost.id
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

  handlePostVerification(postId: number) {
    this.postService.updatePost(postId).subscribe({
      next: () => {
        window.location.reload();
        this.notification = 'Post modifié avec succès !';
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
        window.location.reload();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la suppression du post.';
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }

  handleCommentVerification(commentId: number) {
    this.commentService.updateComment(commentId).subscribe({
      next: () => {
        this.notification = 'Commentaire modifié avec succès !';
        window.location.reload();
        setTimeout(() => this.notification = '', 3000);
      },
      error: () => {
        this.notification = 'Erreur lors de la modification du commentaire.';
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

  handleEditOwnPost(post: any) {
    // postData doit contenir les champs à modifier (title, text, etc.)
    this.postService.updateMyPost(post.id, {
      title: post.title,
      text: post.text,
      location: post.location,
      media: post.media
    }).subscribe({
      next: (updatedPost) => {
        // Mets à jour l'affichage ou affiche une notification de succès
      },
      error: (err) => {
        // Affiche une erreur
      }
    });
  }

  handleStartEditPost(post: any) {
    this.editPostId = post.id;
    this.editPostData = {
      title: post.title,
      text: post.text,
      location: post.location
    };
    this.editErrorMessage = '';
  }

  handleCancelEditPost() {
    this.editPostId = null;
    this.editPostData = { title: '', text: '', location: '' };
    this.editErrorMessage = '';
  }

  handleConfirmEditPost(post: any) {
    if (!this.editPostData.title.trim() || !this.editPostData.text.trim() || !this.editPostData.location.trim()) {
      this.editErrorMessage = 'Tous les champs doivent être remplis.';
      return;
    }
    this.postService.updateMyPost(post.id, {
      title: this.editPostData.title,
      text: this.editPostData.text,
      location: this.editPostData.location
    }).subscribe({
      next: (updatedPost) => {
        // Mets à jour le post dans postData
        post.title = updatedPost.title;
        post.text = updatedPost.text;
        post.location = updatedPost.location;
        this.editPostId = null;
        this.editErrorMessage = '';
        this.notification = 'Post modifié avec succès !';
        setTimeout(() => this.notification = '', 3000);
      },
      error: (err) => {
        this.editErrorMessage = err?.error?.error || "Erreur lors de la modification du post.";
        this.notification = this.editErrorMessage;
        setTimeout(() => this.notification = '', 3000);
      }
    });
  }
}