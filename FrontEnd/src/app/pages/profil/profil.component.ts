import { Component } from '@angular/core';
import { RouterLink, RouterLinkActive } from '@angular/router';
import { CommonModule } from '@angular/common';
import { UserService } from '../../services/user.service';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [CommonModule, FormsModule],
  templateUrl: './profil.component.html',
  styleUrl: './profil.component.css'
})
export class ProfilComponent {
  user: any;
  isLoading: boolean = true;
  editMode: boolean = false;
  changePasswordMode: boolean = false;
  successMessage: string = '';
  errorMessage: string = '';
  showPassword: boolean = false;

  // Champs du formulaire 
  updatedUser: any = {};
  passwordData = {
    current_password: '',
    new_password: '',
    new_password_confirmation: ''
  };

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadUserProfile();
  }

  loadUserProfile(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (!currentUser) {
      console.error('Utilisateur non trouvé dans le stockage local.');
      this.isLoading = false;
      return;
    }

    this.user = currentUser;
    this.updatedUser = {...this.user};
    this.isLoading = false;
  }

  toggleEditMode(): void {
    this.editMode = !this.editMode;
    this.changePasswordMode = false;
    if (this.editMode) {
      // Copie les données pour l'édition
      this.updatedUser = {...this.user};
    }
    this.clearMessages();
  }

  cancelEdit(): void {
    this.editMode = false;
    // Réinitialise les données modifiées
    this.updatedUser = {...this.user};
    this.clearMessages();
  }

  togglePasswordMode(): void {
    this.changePasswordMode = !this.changePasswordMode;
    this.editMode = false;
    this.clearPasswordData();
    this.clearMessages();
  }

  cancelPasswordChange(): void {
    this.changePasswordMode = false;
    this.clearPasswordData();
    this.clearMessages();
  }

  clearPasswordData(): void {
    this.passwordData = {
      current_password: '',
      new_password: '',
      new_password_confirmation: ''
    };
  }

  clearMessages(): void {
    this.successMessage = '';
    this.errorMessage = '';
  }
  submitUserEdit(): void {   
    this.userService.updateUser(this.user.id, this.updatedUser).subscribe({
      next: (response) => {
        if (response && response.user) {
          localStorage.setItem('currentUser', JSON.stringify(response.user))
          this.successMessage = 'Profil mis à jour, rechargement automatique de la page... !';
          this.errorMessage = '';
          this.changePasswordMode = false;
          this.clearPasswordData();
          this.editMode = false;
          
          // Efface le message après 3 secondes
          setTimeout(() => {
            window.location.reload();
            this.successMessage = '';
          }, 1000);
        }
      },
      error: (error) => {
        console.error('Erreur lors de la mise à jour du profil:', error);
        
        if (error.error?.errors) {
          // Convertir l'objet d'erreurs en un seul string
          const errorMessages = Object.values(error.error.errors)
            .flat()
            .join('• ');
            
          this.errorMessage = '• ' + errorMessages;
        } else {
          this.errorMessage = 'Une erreur est survenue lors de la mise à jour du profil.';
        }

        setTimeout(() => {
          this.errorMessage = '';
        }, 10000);
      }
    });
    
    // Efface le message après 3 secondes
    setTimeout(() => {
      this.successMessage = '';
    }, 3000);
  }

  submitPasswordChange(): void {
    this.successMessage = '';
    this.errorMessage = '';
    
    // Validation côté client
    if (this.passwordData.new_password !== this.passwordData.new_password_confirmation) {
      this.errorMessage = 'Les mots de passe ne correspondent pas.';
      return;
    }
  
    this.userService.changePassword(this.user.email, this.passwordData).subscribe({
      next: (response) => {
        this.successMessage = 'Mot de passe changé avec succès.';
        this.changePasswordMode = false;
        this.clearPasswordData();
        
        // Efface le message après 3 secondes
        setTimeout(() => {
          this.successMessage = '';
        }, 3000);
      },
      error: (error) => {
        this.errorMessage = error.error?.message || 'Une erreur est survenue lors du changement de mot de passe.';
      }
    });
  }
}