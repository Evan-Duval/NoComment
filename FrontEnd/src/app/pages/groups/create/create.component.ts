import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { Router } from '@angular/router';
import { CommonModule } from '@angular/common';
import { GroupService } from '../../../services/group.service';
import { UserService } from '../../../services/user.service';
import { SidebarComponent } from '../../../sidebar/sidebar.component';
import { SupabaseService } from '../../../services/supabase.service';

@Component({
  selector: 'app-create',
  standalone: true,
  imports: [ReactiveFormsModule, CommonModule],
  providers: [SidebarComponent],
  templateUrl: './create.component.html',
  styleUrl: './create.component.css'
})
export class CreateGroupComponent {
  userToken: string | null = localStorage.getItem('token');
  createGroupForm: FormGroup;
  group_owner: number = 0;
  successMessage?: string;
  showErrorMessage: boolean = false;
  selectedFile: File | null = null;

  constructor(
    private formBuilder: FormBuilder,
    private groupService: GroupService, 
    private userService: UserService,
    private sidebarComponent: SidebarComponent,
    private supabaseService: SupabaseService,
    private router: Router,
  ) {
    this.createGroupForm = this.formBuilder.group({
      name: [null, Validators.required],
      description: [null, Validators.required],
      logo: [null, [Validators.pattern(/\.(png|jpe?g|svg)$/)]],
    });
  }

  ngOnInit(): void {
    const currentUser = localStorage.getItem('currentUser') ? JSON.parse(localStorage.getItem('currentUser')!) : null;
    if (currentUser) {
      this.group_owner = currentUser.id;
    } else {
      this.showErrorMessage = true
    }
  }

  onFileSelected(event: Event): void {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
      this.selectedFile = input.files[0];
    }
  }

  async onSubmit(): Promise<void> {
    if (!this.createGroupForm.valid || !this.userToken) return;

    const formValues = this.createGroupForm.value;
    let logoPath = 'default_logo.png'; // chemin par défaut

    // S'il y a un fichier sélectionné, on l'upload
    console.log(this.selectedFile)
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

      logoPath = `${fileName}`; // ← chemin stocké en DB
    }

    const createGroupData = {
      name: formValues.name,
      description: formValues.description,
      logo: logoPath,
      group_owner: this.group_owner,
    };

    this.groupService.createGroup(createGroupData).subscribe({
      next: (response) => {
        console.log('Création du groupe réussie', response);
        this.sidebarComponent.reloadSidebar();
        this.successMessage = 'Groupe créé avec succès !';

        setTimeout(() => {
          this.successMessage = undefined;
          this.router.navigate(['/groups']);
        }, 1500);
      },
      error: (error) => {
        console.error('Erreur lors de la création du groupe :', error);
      },
    });
  }

}
